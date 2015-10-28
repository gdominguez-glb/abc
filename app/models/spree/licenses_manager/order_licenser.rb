module Spree
  module LicensesManager
    class OrderLicenser

      def initialize(order)
        @order = order
      end

      def execute
        @order.line_items.each do |line_item|
          create_license(product: line_item.variant.product, quantity: line_item.quantity)
        end
      end

      def create_license(attrs={})
        licensed_product = Spree::LicensedProduct.create!({ order: @order, user: @order.user, skip_salesforce_create: true }.merge(attrs))
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
