require 'fakeweb'

require_relative '../lib/bunny_app'
require_relative '../lib/bunny_app/version'

BunnyApp.config do |c|
  c.access_token = 'xxx'
  c.base_uri = 'http://example.com'
end