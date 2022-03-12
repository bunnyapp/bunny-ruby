require 'fakeweb'

require_relative '../lib/recur_crm'
require_relative '../lib/recur_crm/version'

FakeWeb.register_uri(:post, "http://example.com/graphql", :body => "{}")

RecurCrm.config do |c|
  c.api_key = 'xxx'
  c.base_uri = 'http://example.com'
end