module Spree
  module LicensesManager
    # OrderLicenser
    class OrderLicenser
      def initialize(order)
        @order = order
      end

      def execute
        email = choose_license_email
        @order.line_items.each do |line_item|
          create_license(product: line_item.variant.product,
                         email: email,
                         admin_user: @order.admin_user,
                         quantity: line_item.quantity)
        end


        assign_school_admin_to_order_user
        Spree::LicensesManager::SingleLicenseDistributer.new(email).execute
        send_email_notification
      end

      def create_license(attrs = {})
        licensed_product = Spree::LicensedProduct.create!({
          order: @order,
          skip_salesforce_create: true
        }.merge(attrs))

        if licensed_product.quantity > 1 ||
          @order.enable_single_distribution? ||
          Spree::LicensedProduct.exist_product_license_not_expire?(licensed_product)
          licensed_product.update(can_be_distributed: true, skip_salesforce_create: true)
        end

        if licensed_product.quantity > 1 && !@order.enable_single_distribution?
          SingleLicenseExtractor.new(licensed_product).execute
        end

        licensed_product
      end

      def assign_school_admin_to_order_user
        @order.user.assign_school_admin_role if can_assign_school_admin_to_order_user?
      end

      def can_assign_school_admin_to_order_user?
        @order.user && (@order.enable_single_distribution? || @order.multi_license? || Spree::LicensedProduct.where(user_id: @order.user_id, can_be_distributed: true).exists?)
      end

      def send_email_notification
        if @order.fulfillment?
          LicenseMailer.notify_fulfillment(@order).deliver_now
        elsif @order.license_admin_email.present?
          LicenseMailer.notify_other_admin(@order).deliver_now
        end
      end

      def choose_license_email
        return @order.license_admin_email if @order.license_admin_email.present?
        return @order.user.email if @order.user
        @order.email
      end
    end
  end
end
