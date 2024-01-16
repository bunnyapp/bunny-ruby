module BunnyApp
  class FeatureUsage
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

    def self.create(quantity:, feature_code:, tenant_code:, usage_at: nil)
      variables = {
        attributes: {
          quantity:,
          featureCode: feature_code,
          tenantCode: tenant_code
        }
      }

      variables[:attributes][:usageAt] = usage_at unless usage_at.nil?

      res = Client.new.query(@feature_usage_create_mutation, variables)
      raise ResponseError, res['data']['featureUsageCreate']['errors'].join(',') if res['data']['featureUsageCreate']['errors']

      res['data']['featureUsageCreate']['featureUsage']
    end
  end
end
