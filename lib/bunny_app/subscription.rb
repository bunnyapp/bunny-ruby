module BunnyApp
  class Subscription
    @subscription_create_mutation = <<-GRAPHQL
    mutation subscriptionCreate ($attributes: SubscriptionAttributes!) {
      subscriptionCreate (attributes: $attributes) {
        subscription {
          id
          account {
            id
            name
            contacts {
              id
              firstName
              lastName
            }
          }
          trialStartDate
          trialEndDate
          startDate
          endDate
          state
          evergreen
          plan {
            code
            name
          }
          priceList {
            code
            name
          }
          tenant {
            id
            code
            name
          }
        }
        errors
      }
    }
    GRAPHQL

    @subscription_quantity_update_mutation = <<-GRAPHQL
    mutation subscriptionQuantityUpdate ($subscriptionId: ID!, $quantities: [SubscriptionChargeQuantityAttributes!]!, $invoiceImmediately: Boolean!, $startDate: ISO8601Date!, $name: String!, $allowQuantityLimitsOverride: Boolean!) {
      subscriptionQuantityUpdate (subscriptionId: $subscriptionId, quantities: $quantities, invoiceImmediately: $invoiceImmediately, startDate: $startDate, name: $name, allowQuantityLimitsOverride: $allowQuantityLimitsOverride) {
          errors
          quote {
            id
            name
          }
      }
    }
    GRAPHQL

    @subscription_trial_convert_mutation = <<-GRAPHQL
    mutation subscriptionTrialConvert ($subscriptionId: ID!, $paymentId: ID!, $priceListId: ID!, $priceListCode: String!) {
      subscriptionTrialConvert (subscriptionId: $subscriptionId, paymentId: $paymentId, priceListId: $priceListId, priceListCode: $priceListCode) {
          errors
          invoice {
            amount
            id
            number
            subtotal
          }
          subscription {
            id
            name
          }
      }
    }
    GRAPHQL

    @subscription_cancel_mutation = <<-GRAPHQL
    mutation subscriptionCancel ($ids: [ID!]!) {
      subscriptionCancel (ids: $ids) {
          errors
      }
    }
    GRAPHQL

    # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
    def self.create(price_list_code:, options: {})
      variables = {
        attributes: {
          priceListCode: price_list_code,
          trial: options[:trial] || false,
          evergreen: options[:evergreen] || false
        }
      }

      if options[:account_id]
        variables[:attributes][:accountId] = options[:account_id]
      else
        variables[:attributes][:account] = {
          name: options[:account_name]&.to_s,
          billingContact: {
            firstName: options[:first_name]&.to_s,
            lastName: options[:last_name]&.to_s,
            email: options[:email]&.to_s
          }
        }
      end

      if options[:tenant_code]
        variables[:attributes][:tenant] = {
          code: options[:tenant_code]&.to_s,
          name: options[:tenant_name]&.to_s
        }
      end

      res = Client.new.query(@subscription_create_mutation, variables)
      raise ResponseError, res['data']['subscriptionCreate']['errors'].join(',') if res['data']['subscriptionCreate']['errors']

      res['data']['subscriptionCreate']['subscription']
    end

    def self.quantity_update(subscription_id:, quantities:, options: {})
      variables = {
        subscriptionId: subscription_id,
        quantities:,
        invoiceImmediately: options[:invoice_immediately] || false,
        startDate: options[:start_date],
        name: options[:name],
        allowQuantityLimitsOverride: options[:allow_quantity_limits_override] || false
      }

      res = Client.new.query(@subscription_quantity_update_mutation, variables)
      if res['data']['subscriptionQuantityUpdate']['errors']
        raise ResponseError,
              res['data']['subscriptionQuantityUpdate']['errors'].join(',')
      end

      res['data']['subscriptionQuantityUpdate']['quote']
    end

    def self.trial_convert(subscription_id:, price_list_id: nil, price_list_code: nil, payment_id: nil)
      variables = {
        subscriptionId: subscription_id
      }

      variables[:paymentId] = payment_id if payment_id
      variables[:priceListId] = price_list_id if price_list_id
      variables[:priceListCode] = price_list_code if price_list_code

      res = Client.new.query(@subscription_trial_convert_mutation, variables)
      if res['data']['subscriptionTrialConvert']['errors']
        raise ResponseError,
              res['data']['subscriptionTrialConvert']['errors'].join(',')
      end

      res['data']['subscriptionTrialConvert']
    end

    def self.cancel(subscription_id:)
      variables = {
        ids: [subscription_id]
      }

      res = Client.new.query(@subscription_cancel_mutation, variables)
      raise ResponseError, res['data']['subscriptionCancel']['errors'].join(',') if res['data']['subscriptionCancel']['errors']

      true
    end
  end
end
