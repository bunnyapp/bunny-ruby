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

    def self.create(name:, code:, platform_code: 'default')
      variables = {
        attributes: {
          name: name,
          code: code,
          platformCode: platform_code
        }
      }

      Client.new.query(@environment_create_mutation, variables)
    end
  end
end
