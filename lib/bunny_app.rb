require 'bunny_app/version'
require 'bunny_app/errors'
require 'bunny_app/client'
require 'bunny_app/usage'
require 'bunny_app/platform'
require 'bunny_app/tenant'
require 'bunny_app/subscription'
require 'bunny_app/webhook'

module BunnyApp
  class << self
    attr_accessor :client_id, :client_secret, :scope, :access_token, :retryable
    attr_writer :base_uri

    def config
      yield self
    end

    def base_uri
      @base_uri || 'https://api.bunny.com'
    end

    def query(query, variables)
      Client.new.query(query, variables)
    end

    def query_async(query, variables)
      Client.new.query_async(query, variables)
    end
  end
end
