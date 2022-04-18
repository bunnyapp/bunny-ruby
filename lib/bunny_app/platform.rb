module BunnyApp
  class Platform
    @platform_create_mutation = <<-'GRAPHQL'
    mutation platformCreate ($attributes: PlatformAttributes!) {
      platformCreate (attributes: $attributes) {
        platform {
          id
          name
          code
        }
        errors
      }
    }
    GRAPHQL

    def self.create(name:, code:)
      variables = {
        attributes: {
          name: name,
          code: code
        }
      }

      Client.new.query(@platform_create_mutation, variables)
    end
  end
end
