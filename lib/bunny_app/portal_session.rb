module BunnyApp
  class PortalSession
    @portal_session_create_mutation = <<-'GRAPHQL'
    mutation portalSessionCreate ($tenantCode: String!) {
      portalSessionCreate (tenantCode: $tenantCode) {
          token
          errors
      }
    }
    GRAPHQL

    def self.create(tenant_code:)
      variables = {
        tenantCode: tenant_code
      }

      Client.new.query(@portal_session_create_mutation, variables)
    end
  end
end
