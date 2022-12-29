module BunnyApp
  class Subscription
    @subscription_create_mutation = <<-'GRAPHQL'
    mutation subscriptionCreate ($attributes: SubscriptionAttributes!) {
      subscriptionCreate (attributes: $attributes) {
        errors
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
          productPlan {
            name
          }
          tenant {
            id
            code
            name
          }
        }
      }
  }
    GRAPHQL

    # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
    def self.create(product_plan_code:, options: {})
      variables = {
        attributes: {
          productPlanCode: product_plan_code,
          trial: options[:trial] || false
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

      Client.new.query(@subscription_create_mutation, variables)
    end
  end
end
