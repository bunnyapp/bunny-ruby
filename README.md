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
BunnyApp.config do |c|
  c.access_token = 'ACCESS_TOKEN_HERE' # Don't commit your key to source control!
  c.base_uri = 'https://<subdomain>.bunny.com'
end
```

### Generate rails config

Create a config file at `config/initializers/bunny_app.rb`

```sh
> bin/rails g bunny_app:install
```

### Track feature usage

If you have usage based billing or just want to track feature usage then use this method.

```ruby
# Usage is tracked as if it just happened
json_response = BunnyApp::Usage.track(
  quantity: 5, feature_code: 'products', environment_code: '2')

# Usage is tracked using the date supplied
json_response = BunnyApp::Usage.track(
  quantity: 5, feature_code: 'products', environment_code: '2', usage_at: '2022-03-10')
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
            environment {
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
    environmentCode: "env-123",
    featureCode: "users"
  }
}

json_response = BunnyApp.query(query, variables)
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
