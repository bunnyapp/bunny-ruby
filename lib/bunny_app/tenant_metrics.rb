module BunnyApp
  class TenantMetrics
    @tenant_metrics_update_mutation = <<-'GRAPHQL'
    mutation tenantMetricsUpdate ($code: String!, $attributes: TenantMetricsAttributes!) {
      tenantMetricsUpdate (code: $code, attributes: $attributes) {
          errors
      }
    }
    GRAPHQL

    def self.update(code:, last_login:, user_count:, utilization_metrics: {})
      variables = {
        code:,
        attributes: {
          lastLogin: last_login,
          userCount: user_count,
          utilizationMetrics: utilization_metrics
        }
      }

      Client.new.query(@tenant_metrics_update_mutation, variables)

      true
    end
  end
end
