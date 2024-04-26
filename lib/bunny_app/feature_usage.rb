module BunnyApp
  class FeatureUsage
    @feature_usage_create_mutation = <<-GRAPHQL
    mutation featureUsageCreate ($attributes: FeatureUsageAttributes!) {
        featureUsageCreate (attributes: $attributes) {
            errors
            featureUsage {
                id
                quantity
                usageAt
                subscription {
                    id
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

    def self.create(quantity:, feature_code:, subscription_id:, usage_at: nil)
      variables = {
        attributes: {
          quantity:,
          featureCode: feature_code,
          subscriptionId: subscription_id
        }
      }

      variables[:attributes][:usageAt] = usage_at unless usage_at.nil?

      res = Client.new.query(@feature_usage_create_mutation, variables)
      raise ResponseError, res['data']['featureUsageCreate']['errors'].join(',') if res['data']['featureUsageCreate']['errors']

      res['data']['featureUsageCreate']['featureUsage']
    end
  end
end
