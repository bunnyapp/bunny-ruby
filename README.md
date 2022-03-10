# recur-ruby

Ruby SDK for Recur CRM

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'recurcrm'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install recurcrm
```

## Getting Started

You can use this gem to send customized graphql queries to Recur or use the built in convience methods.

First configure the Recur client.

```ruby
require 'recurcrm'
RecurCrm.config do |c|
  c.api_key = 'API_KEY_HERE' # Don't commit your key to source control!
  c.base_uri = 'https://api.recurcrm.com' # optional. This is the default
end
```

### Track feature usage

If you have usage based billing or just want to track feature usage then use this method.

```ruby
# Usage is tracked as if it just happened
json_response = RecurCrm::Usage.track(
  quantity: 5, feature_code: 'products', environment_code: '2')

# Usage is tracked using the date supplied
json_response = RecurCrm::Usage.track(
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

json_response = RecurCrm.query(query, variables)
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
