# bunny-ruby

Ruby SDK for [Bunny](https://www.bunny.com) — the subscription billing and management platform.

## Installation

Add to your Gemfile:

```ruby
gem 'bunny_app'
```

Then run:

```sh
bundle install
```

Or install directly:

```sh
gem install bunny_app
```

## Configuration

### With client credentials (recommended)

Using `client_id` and `client_secret` enables automatic token refresh when the access token expires.

```ruby
require 'bunny_app'

BunnyApp.config do |c|
  c.client_id     = 'your-client-id'
  c.client_secret = 'your-client-secret'
  c.scope         = 'standard:read standard:write'
  c.base_uri      = 'https://<subdomain>.bunny.com'
end
```

### With a pre-existing access token

If you manage token lifecycle yourself, you can pass the token directly. An `AuthorizationError` will be raised if the token expires.

```ruby
BunnyApp.config do |c|
  c.access_token = 'your-access-token'
  c.base_uri     = 'https://<subdomain>.bunny.com'
end
```

> **Never commit secrets to source control.** Load credentials from environment variables or a secret store.

### Rails initializer

Generate a config file at `config/initializers/bunny_app.rb`:

```sh
bin/rails g bunny_app:install
```

This creates a template that reads credentials from environment variables:

```ruby
BunnyApp.config do |c|
  c.client_id     = ENV['BUNNY_APP_CLIENT_ID']
  c.client_secret = ENV['BUNNY_APP_CLIENT_SECRET']
  c.scope         = ENV['BUNNY_APP_SCOPE']
  c.base_uri      = 'https://<subdomain>.bunny.com'
end
```

---

## Subscriptions

### Create a subscription

Create a new subscription for an account. You can create the account inline or attach to an existing account by ID.

```ruby
# Create with a new account
subscription = BunnyApp::Subscription.create(
  price_list_code: 'starter',
  options: {
    account_name: 'Acme Corp',
    first_name:   'Jane',
    last_name:    'Smith',
    email:        'jane@acme.com',
    trial:        true,
    tenant_code:  'acme-123',
    tenant_name:  'Acme Corp'
  }
)

# Create against an existing account
subscription = BunnyApp::Subscription.create(
  price_list_code: 'starter',
  options: {
    account_id:  '456',
    tenant_code: 'acme-123',
    tenant_name: 'Acme Corp'
  }
)
```

Returns a hash containing the created subscription, including `id`, `state`, `trialStartDate`, `trialEndDate`, `plan`, `priceList`, and `tenant`.

### Update subscription quantities

Adjust the quantities for one or more charges on an existing subscription.

```ruby
quote = BunnyApp::Subscription.quantity_update(
  subscription_id: '456123',
  quantities: [
    { code: 'users', quantity: 25 }
  ],
  options: {
    invoice_immediately:          true,
    start_date:                   '2024-06-01',
    name:                         'Add users — June',
    allow_quantity_limits_override: false
  }
)
```

Returns a `quote` hash with `id` and `name`.

### Convert a trial to paid

```ruby
# Convert using a price list code
result = BunnyApp::Subscription.trial_convert(
  subscription_id: '456123',
  price_list_code: 'starter'
)

# Convert using a price list ID and payment method
result = BunnyApp::Subscription.trial_convert(
  subscription_id: '456123',
  price_list_id:   '789',
  payment_id:      '101112'
)
```

Returns a hash containing `invoice` (with `amount`, `id`, `number`, `subtotal`) and `subscription` (with `id`, `name`).

### Cancel a subscription

```ruby
BunnyApp::Subscription.cancel(subscription_id: '456123')
# => true
```

---

## Tenants

### Create a tenant

```ruby
tenant = BunnyApp::Tenant.create(
  name:          'Acme Corp',
  code:          'acme-123',
  account_id:    '456',
  platform_code: 'main'   # optional, defaults to 'main'
)
```

Returns a hash with `id`, `code`, `name`, and `platform`.

### Find a tenant by code

```ruby
tenant = BunnyApp::Tenant.find_by(code: 'acme-123')
# => { "id" => "1", "code" => "acme-123", "name" => "Acme Corp",
#      "subdomain" => "acme", "account" => { "id" => "456", ... } }
```

Returns `nil` if no tenant is found.

---

## Tenant Metrics

Push usage and engagement metrics to Bunny for a tenant. Useful for health scoring and churn signals.

```ruby
BunnyApp::TenantMetrics.update(
  code:       'acme-123',
  last_login: '2024-06-01T12:00:00Z',
  user_count: 42,
  utilization_metrics: {
    projects_created: 10,
    exports_run:      3
  }
)
# => true
```

`utilization_metrics` is optional and accepts any key/value pairs you want to track.

---

## Feature Usage

Track usage of individual features for usage-based billing or analytics.

```ruby
# Track usage now
usage = BunnyApp::FeatureUsage.create(
  quantity:        5,
  feature_code:    'api_calls',
  subscription_id: '456123'
)

# Track usage for a specific date
usage = BunnyApp::FeatureUsage.create(
  quantity:        5,
  feature_code:    'api_calls',
  subscription_id: '456123',
  usage_at:        '2024-03-10'
)
```

Returns a hash with `id`, `quantity`, `usageAt`, `subscription`, and `feature`.

---

## Portal Sessions

Generate a short-lived token to embed the Bunny billing portal in your app using Bunny.js.

```ruby
# Basic session
token = BunnyApp::PortalSession.create(tenant_code: 'acme-123')

# With a return URL and custom expiry (in hours, default: 24)
token = BunnyApp::PortalSession.create(
  tenant_code:  'acme-123',
  return_url:   'https://yourapp.com/billing',
  expiry_hours: 4
)
```

Returns the session token string.

---

## Platforms

Platforms allow you to group tenants. Create a platform before assigning tenants to it.

```ruby
platform = BunnyApp::Platform.create(
  name: 'My SaaS Platform',
  code: 'my-saas'
)
# => { "id" => "1", "name" => "My SaaS Platform", "code" => "my-saas" }
```

---

## Webhooks

Bunny sends webhooks for events like subscription state changes. Verify the `x-bunny-signature` header to confirm the payload is authentic.

```ruby
payload    = request.raw_post
signature  = request.headers['x-bunny-signature']
signing_key = ENV['BUNNY_WEBHOOK_SECRET']

if BunnyApp::Webhook.verify(signature, payload, signing_key)
  # payload is authentic — process the event
  event = JSON.parse(payload)
  case event['type']
  when 'SubscriptionProvisioningChange'
    # handle provisioning change
  end
else
  head :unauthorized
end
```

---

## Custom GraphQL Queries

You can send any GraphQL query or mutation directly if you need fields not covered by the convenience methods.

### Synchronous query

```ruby
query = <<~GRAPHQL
  query GetTenant($code: String!) {
    tenant(code: $code) {
      id
      name
      account {
        id
        name
      }
    }
  }
GRAPHQL

response = BunnyApp.query(query, { code: 'acme-123' })
tenant = response['data']['tenant']
```

### Asynchronous query (fire-and-forget)

Runs the request in a background thread. Useful for non-critical tracking calls where you don't want to block the request cycle.

```ruby
BunnyApp.query_async(query, variables)
```

---

## Error Handling

All convenience methods raise on error. Two exception classes are provided:

| Exception | When raised |
|---|---|
| `BunnyApp::AuthorizationError` | Invalid or expired credentials |
| `BunnyApp::ResponseError` | API returned errors in the response body |

```ruby
begin
  BunnyApp::Subscription.cancel(subscription_id: '456123')
rescue BunnyApp::AuthorizationError => e
  # Re-authenticate or alert
  Rails.logger.error "Bunny auth failed: #{e.message}"
rescue BunnyApp::ResponseError => e
  # The API rejected the request
  Rails.logger.error "Bunny error: #{e.message}"
end
```

---

## Requirements

Ruby 2.5+

---

## Development

```sh
bundle install          # install dependencies
bundle exec rake spec   # run tests
bin/console             # interactive console
```

Set `IGNORE_SSL=true` when running locally to suppress SSL warnings:

```sh
IGNORE_SSL=true bin/console
```

## Publishing

Update `lib/bunny_app/version.rb`, then:

```sh
gem build
gem push bunny_app-x.x.x.gem
```

The RubyGems account is protected by MFA and managed by @richet.
