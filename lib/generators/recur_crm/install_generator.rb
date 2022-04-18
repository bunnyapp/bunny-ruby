require 'rails/generators'
require 'bunny_crm'

module BunnyCrm
  class InstallGenerator < Rails::Generators::Base
    desc 'This generator creates a configuration file for the Bunny CRM ruby client inside config/initializers'
    def create_configuration_file
      initializer 'bunny_crm.rb' do
        <<~CONFIG
          # Specifies configuration options for the Bunny CRM gem.
          BunnyCrm.config do |c|

            # This is where your API key goes. You should almost certainly not have it
            # committed to source control, but instead load it from a secret store.
            # Default: nil
            c.api_key = ENV['BUNNY_CRM_API_TOKEN']

            # Optional. Base URI for the Bunny API
            # c.base_uri = 'https://api.bunny.com'

          end
        CONFIG
      end
    end
  end
end
