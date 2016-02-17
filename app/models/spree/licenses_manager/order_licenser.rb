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

        send_email_notification
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

      def send_email_notification
        if @order.fulfillment?
          LicenseMailer.notify_fulfillment(@order)
        elsif @order.license_admin_email.present?
          LicenseMailer.notify_other_admin(@order)
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
