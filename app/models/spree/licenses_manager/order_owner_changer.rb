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
        assign_school_admin_to_order_user
      end

      def assign_school_admin_to_order_user
        @order.user.assign_school_admin_role if can_assign_school_admin_to_order_user?
      end

      def can_assign_school_admin_to_order_user?
        @order.user && (@order.enable_single_distribution? || @order.multi_license? || Spree::LicensedProduct.where(user_id: @order.user_id, can_be_distributed: true).exists?)
      end

    end
  end
end
