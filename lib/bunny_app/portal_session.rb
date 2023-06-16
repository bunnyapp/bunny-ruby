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

    def self.create(tenant_code:, expiry_hours: 24, return_url: nil)
      variables = {
        tenantCode: tenant_code,
        returnUrl: return_url,
        expiry: expiry_hours
      }

      Client.new.query(@portal_session_create_mutation, variables)
    end
  end
end
