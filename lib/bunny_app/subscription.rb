module BunnyApp
  class Subscription
    @subscription_create_mutation = <<-'GRAPHQL'
    mutation subscriptionCreate ($attributes: SubscriptionAttributes!) {
      subscriptionCreate (attributes: $attributes) {
        subscription {
          id
          account {
            id
            name
            contacts {
              id
              firstName
              lastName
            }
          }
          trialStartDate
          trialEndDate
          startDate
          endDate
          state
          evergreen
          plan {
            code
            name
          }
          priceList {
            code
            name
          }
          tenant {
            id
            code
            name
          }
        }
        errors
      }
    }
    GRAPHQL

    @subscription_cancel_mutation = <<-'GRAPHQL'
    mutation subscriptionCancel ($ids: [ID!]!) {
      subscriptionCancel (ids: $ids) {
          errors
      }
    }
    GRAPHQL

    # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
    def self.create(price_list_code:, options: {})
      variables = {
        attributes: {
          priceListCode: price_list_code,
          trial: options[:trial] || false,
          evergreen: options[:evergreen] || false
        }
      }

      if options[:account_id]
        variables[:attributes][:accountId] = options[:account_id]
      else
        variables[:attributes][:account] = {
          name: options[:account_name]&.to_s,
          billingContact: {
            firstName: options[:first_name]&.to_s,
            lastName: options[:last_name]&.to_s,
            email: options[:email]&.to_s
          }
        }
      end

      if options[:tenant_code]
        variables[:attributes][:tenant] = {
          code: options[:tenant_code]&.to_s,
          name: options[:tenant_name]&.to_s
        }
      end

      res = Client.new.query(@subscription_create_mutation, variables)
      res['data']['subscriptionCreate']['subscription']
    end

    def self.cancel(subscription_id:)
      variables = {
        ids: [subscription_id]
      }

      Client.new.query(@subscription_cancel_mutation, variables)

      true
    end
  end
end
