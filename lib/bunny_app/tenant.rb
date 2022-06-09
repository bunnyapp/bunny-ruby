module BunnyApp
  class Tenant
    @tenant_create_mutation = <<-'GRAPHQL'
    mutation tenantCreate ($attributes: TenantAttributes!, $subscriptionId: ID!) {
      tenantCreate (attributes: $attributes, subscriptionId: $subscriptionId) {
        tenant {
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

      Client.new.query(@tenant_create_mutation, variables)
    end
  end
end
