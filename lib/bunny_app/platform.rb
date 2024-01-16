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
          name:,
          code:
        }
      }

      res = Client.new.query(@platform_create_mutation, variables)
      raise ResponseError, res['data']['platformCreate']['errors'].join(',') if res['data']['platformCreate']['errors']

      res['data']['platformCreate']['platform']
    end
  end
end
