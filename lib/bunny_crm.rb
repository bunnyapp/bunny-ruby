require 'bunny_crm/version'
require 'bunny_crm/errors'
require 'bunny_crm/client'
require 'bunny_crm/usage'
require 'bunny_crm/platform'
require 'bunny_crm/environment'

module BunnyCrm
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
