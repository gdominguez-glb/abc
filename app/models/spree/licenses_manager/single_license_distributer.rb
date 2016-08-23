module Spree
  module LicensesManager
    class SingleLicenseDistributer

      def initialize(email)
        @email = email
      end

      def execute
        if Spree::LicensedProduct.where(email: @email).group(:product_id).select('count(*) as product_count, product_id').select{|lp| lp.product_count > 1 }.present?
          distribute_single_license
        end
      end

      def distribute_single_license
        Spree::LicensedProduct.where(
          can_be_distributed: false,
          quantity: 1,
          email: @email).each do |licensed_product|

            next if licensed_product.product_distribution && licensed_product.product_distribution.email == @email && licensed_product.product_distribution.from_email == @email

          distributed_licensed_product = licensed_product.dup
          distributed_licensed_product.update(can_be_distributed: false, quantity: 1, skip_salesforce_create: true, skip_next_salesforce_update: true)
          product_distribution = Spree::ProductDistribution.create(
            licensed_product:    licensed_product,
            from_user_id:        licensed_product.user_id,
            from_email:          licensed_product.email,
            to_user_id:          licensed_product.user_id,
            email:               licensed_product.email,
            quantity:            1,
            product_id:          licensed_product.product_id,
            expire_at:           licensed_product.expire_at
          )
          distributed_licensed_product.update(product_distribution: product_distribution, skip_next_salesforce_update: true)
          licensed_product.update(can_be_distributed: true, quantity: 0, skip_next_salesforce_update: true)
        end
      end

    end
  end
end
