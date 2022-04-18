require 'httparty'
require 'json'

module BunnyCrm
  class Client
    include HTTParty

    attr_accessor :headers

    USER_AGENT = "BunnyCrm Ruby v#{BunnyCrm::VERSION}".freeze

    def initialize
      self.class.base_uri BunnyCrm.base_uri
      self.class.default_options.update(verify: verify_ssl)

      @api_key = BunnyCrm.api_key
      @headers = {
        'User-Agent' => USER_AGENT,
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{BunnyCrm.api_key}"
      }
    end

    def query(query, variables)
      body = {
        query: query,
        variables: variables
      }.to_json

      res = self.class.post('/graphql', headers: @headers, body: body)

      case res.code.to_s
      when /2[0-9][0-9]/ # HTTP 2xx
        res.body
      when /40[13]/ # HTTP 401,403
        raise AuthorizationError, res.body
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
