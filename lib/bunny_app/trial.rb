module BunnyApp
  class Trial
    @trial_create_mutation = <<-'GRAPHQL'
    mutation trialCreate ($attributes: TrialAttributes!) {
      trialCreate (attributes: $attributes) {
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

    def self.create(account_name:, first_name:, last_name:, email:, product_plan_code:, options: {})
      variables = {
        attributes: {
          company: account_name,
          firstName: first_name,
          lastName: last_name,
          email: email,
          productPlanCode: product_plan_code,
          trialStartDate: options[:trial_start_date],
          platformCode: options[:platform_code],
          environmentCode: options[:environment_code]
        }
      }

      Client.new.query(@trial_create_mutation, variables)
    end
  end
end
