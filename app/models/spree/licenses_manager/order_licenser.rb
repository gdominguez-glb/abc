module Spree
  module LicensesManager
    # OrderLicenser
    class OrderLicenser
      def initialize(order)
        @order = order
      end

      def execute
        email = (@order.license_admin_email || @order.user.try(:email) || @order.email)
        @order.line_items.each do |line_item|
          create_license(product: line_item.variant.product,
                         email: email,
                         quantity: line_item.quantity)
        end
      end

      def create_license(attrs = {})
        licensed_product = Spree::LicensedProduct.create!({
          order: @order, skip_salesforce_create: true
        }.merge(attrs))

        licensed_product.skip_salesforce_create = false
        if licensed_product.quantity > 1
          licensed_product.update(can_be_distributed: true)
          SingleLicenseExtractor.new(licensed_product).execute
        end
        licensed_product.create_in_salesforce
        licensed_product
      end
    end
  end
end
