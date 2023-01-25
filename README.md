# bunny-ruby

Ruby SDK for Bunny

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bunnyapp'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install bunnyapp
```

## Getting Started

You can use this gem to send customized graphql queries to Bunny or use the built in convience methods.

First configure the Bunny client.

```ruby
require 'bunny_app'

# We recommend using the client_id/secret of your Bunny client app
# this will enable automatic retries when the access token expires
BunnyApp.config do |c|
  c.client_id = 'xxx'
  c.client_secret = 'xxx'
  c.scope = 'standard:read standard:write'
  c.base_uri = 'https://<subdomain>.bunny.com'
end

# Alternately you can generate the access token outside of this sdk
# be aware that if your access_token expires an exception will be raised
BunnyApp.config do |c|
  c.access_token = 'xxx'
  c.base_uri = 'https://<subdomain>.bunny.com'
end
```

> Remember! Don't commit secrets to source control!

### Generate rails config

Create a config file at `config/initializers/bunny_app.rb`

```sh
> bin/rails g bunny_app:install
```

### Create a subscription

```ruby
response = BunnyApp::Subscription.create(
  price_list_code: 'starter',
  options: {
    account_name: "Superdesk",
    first_name: "Meg",
    last_name: "La Don",
    email: "meg@example.com",
    trial: true,
    tenant_code: "123456",
    tenant_name: "Superdesk"
  }
)
```

### Get a portal session token for use with Bunny.js

```ruby
response = BunnyApp::PortalSession.create(
  tenant_code: "123456"
)
```

### Track feature usage

If you have usage based billing or just want to track feature usage then use this method.

```ruby
# Usage is tracked as if it just happened
response = BunnyApp::Usage.track(
  quantity: 5, feature_code: 'products', tenant_code: '2')

# Usage is tracked using the date supplied
response = BunnyApp::Usage.track(
  quantity: 5, feature_code: 'products', tenant_code: '2', usage_at: '2022-03-10')
```

### Custom queries & mutations

Alternately you can build and send your own custom graphql queries or mutations

```ruby
query = <<-'GRAPHQL'
mutation featureUsageCreate ($attributes: FeatureUsageAttributes!) {
    featureUsageCreate (attributes: $attributes) {
        errors
        featureUsage {
            id
            quantity
            usageAt
            tenant {
                id
                code
                name
            }
            feature {
                id
                code
                name
            }
        }
    }
}
GRAPHQL

variables = {
  attributes: {
    quantity: 1,
    usageAt: "2022-03-10",
    tenantCode: "123456",
    featureCode: "users"
  }
}

response = BunnyApp.query(query, variables)
```

### Verify webhook signature

Bunny can send webhooks for key actions like a subscription change. When you get a webhook from Bunny you should verify the signature that is supplied in the `x-bunny-signature` header matches the payload.

```ruby
payload = '{"type":"SubscriptionProvisioningChange","payload":{"subscription":{"id":27,"state":"trial","trial_start_date":"2022-06-04","trial_end_date":"2022-06-18","start_date":null,"end_date":null,"auto_renew":false,"account":{"id":33,"name":"Ondricka, Flatley and Kessler"},"tenant":null,"product":{"code":"stealth","name":"Stealth","description":null,"sku":null},"features":[{"code":"users","quantity":1},{"code":"crm","quantity":null}]}}}'

BunnyApp::Webhook.verify("8bd5aa9c6a96fbce9fc3065af6e9871ac19a1d0a", payload, "secret-key")
```

## Requirements

This gem requires Ruby 2.5+

## Development

Run `bin/setup` to install dependencies.

Run `rake spec` to run the tests.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Set IGNORE_SSL when running locally to ignore ssl warnings.

```sh
> IGNORE_SSL=true bin/console
```
