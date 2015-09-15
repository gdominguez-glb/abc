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
        licensed_product = Spree::LicensedProduct.create!({ order: @order, user: @order.user }.merge(attrs))
        distribute_license_to_self(licensed_product) if licensed_product.quantity > 1 
        licensed_product
      end

      def distribute_license_to_self(licensed_product)
        SingleLicenseExtractor.new(licensed_product).execute
      end

    end
  end
end
