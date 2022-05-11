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

            # This is where your API credentials go. You should almost certainly not have it
            # committed to source control, but instead load it from a secret store.
            c.client_id = ENV['BUNNY_APP_CLIENT_ID']
            c.client_secret = ENV['BUNNY_APP_CLIENT_SECRET']
            c.scope = ENV['BUNNY_APP_SCOPE']

            # Base URI for the Bunny API
            c.base_uri = 'https://<subdomain>.bunny.com'

            # Optional.
            # Use this instead of client_id/secret if you dont care about the token expiring
            # c.access_token = ENV['BUNNY_APP_ACCESS_TOKEN']

          end
        CONFIG
      end
    end
  end
end
