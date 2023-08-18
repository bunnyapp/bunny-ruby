require 'httparty'
require 'json'

module BunnyApp
  class Client
    include HTTParty

    attr_accessor :headers

    USER_AGENT = "BunnyApp Ruby v#{BunnyApp::VERSION}".freeze

    def initialize
      self.class.base_uri BunnyApp.base_uri
      self.class.default_options.update(verify: verify_ssl)

      BunnyApp.access_token ||= fetch_access_token
      @headers = {
        'User-Agent' => USER_AGENT,
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{BunnyApp.access_token}"
      }
    end

    def fetch_access_token
      body = URI.encode_www_form({
                                   grant_type: 'client_credentials',
                                   client_id: BunnyApp.client_id,
                                   client_secret: BunnyApp.client_secret,
                                   scope: BunnyApp.scope
                                 })

      headers = {
        'Content-Type' => 'application/x-www-form-urlencoded'
      }

      res = self.class.post('/oauth/token', headers:, body:)

      case res.code.to_s
      when /2[0-9][0-9]/ # HTTP 2xx
        BunnyApp.retryable = true
        res['access_token']
      when /40[0-9]/
        raise AuthorizationError, res.parsed_response['error_description']
      else
        raise ResponseError, res.body
      end
    end

    def query(query, variables, retries = 0)
      body = {
        query:,
        variables:
      }.to_json

      @headers['Authorization'] = "Bearer #{BunnyApp.access_token}"

      res = self.class.post('/graphql', headers: @headers, body:)

      case res.code.to_s
      when /2[0-9][0-9]/ # HTTP 2xx
        response_body = JSON.parse(res.body)
        raise ResponseError, (response_body['errors'].map { |error| error['message'] }) if response_body['errors']

        response_body

      when /401/ # Access Token Expired
        raise AuthorizationError, 'Invalid access token' unless BunnyApp.retryable
        raise AuthorizationError, 'Invalid api credentials' if retries >= 1

        BunnyApp.access_token = fetch_access_token
        retries += 1
        query(query, variables, retries)

      when /403/ # HTTP 403
        raise AuthorizationError, res.parsed_response['error_decscription']
      else
        raise ResponseError, res.body # HTTP 400, 500 etc
      end
    end

    # Performs the api request within a new Thread, so it is non blocking.
    # Consider it fire and forget
    def query_async(query, variables)
      Thread.new do
        query(query, variables)
      end
    end

    def verify_ssl
      return true unless ENV['IGNORE_SSL']
    end
  end
end
