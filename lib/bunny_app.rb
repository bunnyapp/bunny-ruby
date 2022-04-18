require 'bunny_app/version'
require 'bunny_app/errors'
require 'bunny_app/client'
require 'bunny_app/usage'
require 'bunny_app/platform'
require 'bunny_app/environment'

module BunnyApp
  class << self
    attr_accessor :api_key
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
