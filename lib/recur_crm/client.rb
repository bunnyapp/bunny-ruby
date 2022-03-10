require 'httparty'
require 'json'

module RecurCrm
  class Client
    USER_AGENT = "RecurCrm Ruby v#{RecurCrm::VERSION}".freeze

    include HTTParty

    def initialize
      self.class.base_uri RecurCrm.base_uri
      self.class.default_options.update(verify: verify_ssl)

      @api_key = RecurCrm.api_key
      @headers = {
        'User-Agent' => USER_AGENT,
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{RecurCrm.api_key}"
      }
    end

    def query(query, variables)
      body = {
        query: query,
        variables: variables
      }.to_json

      self.class.post('/graphql', headers: @headers, body: body).body
    end

    # Performs the api request within a new Thread, so it is non blocking.
    # Consider it fire and forget
    def query_async(query, variables)
      Thread.new do
        query(query, variables)
      end
    end

    def verify_ssl
      puts ENV['IGNORE_SSL']
      return true unless ENV['IGNORE_SSL']
    end
  end
end