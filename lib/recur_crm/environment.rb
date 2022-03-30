module RecurCrm
  class Environment
    @environment_create_mutation = <<-'GRAPHQL'
    mutation environmentCreate ($attributes: EnvironmentAttributes!) {
      environmentCreate (attributes: $attributes) {
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

    def self.create(name:, code:, platform_code: 'default', subscription_id: nil)
      variables = {
        attributes: {
          name: name,
          code: code,
          platformCode: platform_code
        }
      }

      variables[:subscriptionId] = subscription_id unless subscription_id.nil?

      Client.new.query(@environment_create_mutation, variables)
    end
  end
end
