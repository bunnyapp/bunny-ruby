module BunnyApp
  class Subscription
    @subscription_create_mutation = <<-'GRAPHQL'
    mutation subscriptionCreate ($attributes: TrialAttributes!) {
      subscriptionCreate (attributes: $attributes) {
          errors
          subscription {
              id
              trialStartDate
              trialEndDate
              startDate
              endDate
              state
              productPlan {
                name
              }
          }
      }
  }
    GRAPHQL

    def self.create(account_name:, first_name:, last_name:, email:, product_plan_code:, trial_start_date: Time.now.iso8601)
      variables = {
        attributes: {
          company: account_name,
          firstName: first_name,
          lastName: last_name,
          email: email,
          productPlanCode: product_plan_code,
          trialStartDate: trial_start_date
        }
      }

      Client.new.query(@subscription_create_mutation, variables)
    end
  end
end
