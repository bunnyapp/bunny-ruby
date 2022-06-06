module BunnyApp
  class Environment
    @environment_create_mutation = <<-'GRAPHQL'
    mutation environmentCreate ($attributes: EnvironmentAttributes!, $subscriptionId: ID!) {
      environmentCreate (attributes: $attributes, subscriptionId: $subscriptionId) {
        environment {
          code
          id
          name
          platform {
            id
            name
            code
          }
        }
        errors
      }
    }
    GRAPHQL

    def self.create(name:, code:, platform_code: 'main', subscription_id: nil)
      variables = {
        attributes: {
          name:,
          code:,
          platformCode: platform_code
        },
        subscriptionId: subscription_id
      }

      Client.new.query(@environment_create_mutation, variables)
    end
  end
end
