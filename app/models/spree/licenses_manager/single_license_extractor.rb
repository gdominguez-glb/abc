module Spree
  module LicensesManager
    class SingleLicenseExtractor
      def initialize(licensed_product)
        @licensed_product = licensed_product
      end

      def execute
        return if exist_product_license_not_expire?
        Spree::LicensedProduct.transaction do
          create_new_license(create_distribution)
          update_original_license
        end
      end

      def exist_product_license_not_expire?
        Spree::LicensedProduct.
          where("email = ?", @licensed_product.email).
          where(can_be_distributed: false, product_id: @licensed_product.product_id).
          where("id != ?", @licensed_product.id).
          where("expire_at > ?", Time.now).
          exists?
      end

      def create_new_license(distribution)
        single_licensed_product = @licensed_product.dup
        single_licensed_product.salesforce_reference = nil
        single_licensed_product.update!(
          quantity: 1,
          product_distribution_id: distribution.id,
          can_be_distributed: false,
          skip_notification: true)
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
          product_id:          @licensed_product.product_id
        )
      end

      def update_original_license
        @licensed_product.update(quantity: @licensed_product.quantity - 1)
      end
    end
  end
end
