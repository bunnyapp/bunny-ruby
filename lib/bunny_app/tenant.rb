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

    @tenant_query = <<-'GRAPHQL'
    query tenant ($code: String!) {
      tenant (code: $code) {
        id
        code
        name
        subdomain
        account {
          id
          name
          billingDay
        }
        latestProvisioningChange {
            change
            createdAt
            features
            id
            updatedAt
        }
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

      res = Client.new.query(@tenant_create_mutation, variables)
      res['data']['tenantCreate']['tenant']
    end

    def self.find_by(code:)
      variables = {
        code:
      }

      res = Client.new.query(@tenant_query, variables)
      res['data']['tenant']
    end
  end
end
