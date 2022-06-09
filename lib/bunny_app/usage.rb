module BunnyApp
  class Usage
    @feature_usage_create_mutation = <<-'GRAPHQL'
    mutation featureUsageCreate ($attributes: FeatureUsageAttributes!) {
        featureUsageCreate (attributes: $attributes) {
            errors
            featureUsage {
                id
                quantity
                usageAt
                tenant {
                    id
                    code
                    name
                }
                feature {
                    id
                    code
                    name
                }
            }
        }
    }
    GRAPHQL

    def self.track(quantity:, feature_code:, tenant_code:, usage_at: nil)
      variables = {
        attributes: {
          quantity:,
          featureCode: feature_code,
          tenantCode: tenant_code
        }
      }

      variables[:attributes][:usageAt] = usage_at unless usage_at.nil?

      Client.new.query(@feature_usage_create_mutation, variables)
    end
  end
end
