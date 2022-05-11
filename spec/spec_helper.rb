require 'fakeweb'

require_relative '../lib/bunny_app'
require_relative '../lib/bunny_app/version'

FakeWeb.register_uri(:post, "http://example.com/graphql", :body => "{}")

BunnyApp.config do |c|
  c.access_token = 'xxx'
  c.base_uri = 'http://example.com'
end