module BunnyApp
  class Tenant
    @tenant_create_mutation = <<-'GRAPHQL'
    mutation tenantCreate ($attributes: TenantAttributes!) {
      tenantCreate (attributes: $attributes) {
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

    def self.create(name:, code:, account_id:, platform_code: 'main')
      variables = {
        attributes: {
          name:,
          code:,
          platformCode: platform_code,
          accountId: account_id
        }
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
