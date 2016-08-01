module Spree
  module LicensesManager
    # SingleLicenseExtractor
    class SingleLicenseExtractor
      def initialize(licensed_product, skip_salesforce_create=true)
        @licensed_product = licensed_product
        @skip_salesforce_create = skip_salesforce_create
      end

      def execute
        return @licensed_product if Spree::LicensedProduct.exist_product_license_not_expire?(@licensed_product)
        Spree::LicensedProduct.transaction do
          create_new_license(create_distribution)
          update_original_license
        end
      end

      def create_new_license(distribution)
        Spree::LicensedProduct.create(
          email: @licensed_product.email,
          product: @licensed_product.product,
          product_distribution: distribution,
          order: @licensed_product.order,
          quantity: 1,
          product_distribution_id: distribution.id,
          can_be_distributed: false,
          skip_notification: true,
          skip_salesforce_create: @skip_salesforce_create
        )
      end

      def create_distribution
        user_id    = @licensed_product.user.try(:id)
        user_email = @licensed_product.email

        Spree::ProductDistribution.create!(
          licensed_product:    @licensed_product,
          from_user_id:        user_id,
          from_email:          user_email,
          to_user_id:          user_id,
          email:               user_email,
          quantity:            1,
          product_id:          @licensed_product.product_id,
          expire_at:           @licensed_product.expire_at
        )
      end

      def update_original_license
        @licensed_product.tap do
          @licensed_product.update(quantity: @licensed_product.quantity - 1, skip_salesforce_create: @skip_salesforce_create)
        end
      end
    end
  end
end
