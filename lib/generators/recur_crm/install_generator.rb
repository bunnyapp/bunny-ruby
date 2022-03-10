require 'rails/generators'
require 'recur_crm'

module RecurCrm
  class InstallGenerator < Rails::Generators::Base
    desc 'This generator creates a configuration file for the Recur CRM ruby client inside config/initializers'
    def create_configuration_file
      initializer 'recur_crm.rb' do
        <<~CONFIG
          # Specifies configuration options for the Recur CRM gem.
          RecurCrm.config do |c|

            # This is where your API key goes. You should almost certainly not have it
            # committed to source control, but instead load it from a secret store.
            # Default: nil
            c.api_key = ENV['RECURCRM_API_TOKEN']

            # Optional. Base URI for the Recur API
            # c.base_uri = 'https://api.recurcrm.com'

          end
        CONFIG
      end
    end
  end
end
