require 'fakeweb'

require_relative '../lib/bunny_crm'
require_relative '../lib/bunny_crm/version'

FakeWeb.register_uri(:post, "http://example.com/graphql", :body => "{}")

BunnyCrm.config do |c|
  c.api_key = 'xxx'
  c.base_uri = 'http://example.com'
end