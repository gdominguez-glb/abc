module Spree
  module LicensesManager
    class OrderOwnerChanger

      def initialize(order)
        @order = order
      end

      def execute
        Spree::LicensedProduct.where(order_id: @order.id).each do |lp|
          lp.update(user: @order.user, email: @order.email)
          Spree::ProductDistribution.where(licensed_product_id: lp.id).each do |pd|
            pd.update(from_user: @order.user, to_user: @order.user, email: @order.email, from_email: @order.email)
          end
        end
      end

    end
  end
end
