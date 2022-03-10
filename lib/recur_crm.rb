require 'recur_crm/version'
require 'recur_crm/client'
require 'recur_crm/usage'

module RecurCrm
  class << self
    attr_accessor :api_key
    attr_writer :base_uri

    def config
      yield self
    end

    def base_uri
      @base_uri || 'https://api.recurcrm.com'
    end

    def query(query, variables)
      Client.new.query(query, variables)
    end

    def query_async(query, variables)
      Client.new.query_async(query, variables)
    end
  end
end
