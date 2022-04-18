require 'rails/generators'
require 'bunny_app'

module BunnyApp
  class InstallGenerator < Rails::Generators::Base
    desc 'This generator creates a configuration file for the Bunny ruby client inside config/initializers'
    def create_configuration_file
      initializer 'bunny_app.rb' do
        <<~CONFIG
          # Specifies configuration options for the Bunny gem.
          BunnyApp.config do |c|

            # This is where your API key goes. You should almost certainly not have it
            # committed to source control, but instead load it from a secret store.
            # Default: nil
            c.api_key = ENV['bunny_app_API_TOKEN']

            # Optional. Base URI for the Bunny API
            # c.base_uri = 'https://api.bunny.com'

          end
        CONFIG
      end
    end
  end
end
