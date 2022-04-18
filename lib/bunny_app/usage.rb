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
                environment {
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

    def self.track(quantity:, feature_code:, environment_code:, usage_at: DateTime.now.iso8601)
      variables = {
        attributes: {
          quantity: quantity,
          featureCode: feature_code,
          environmentCode: environment_code,
          usageAt: usage_at
        }
      }

      Client.new.query(@feature_usage_create_mutation, variables)
    end
  end
end
