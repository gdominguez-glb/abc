module Spree
  module LicensesManager
    class LicensesDistributer

      def initialize(attrs={})
        @user              = attrs[:user]
        @rows              = attrs[:rows]
        @licensed_products = attrs[:licensed_products]

        @product = @licensed_products.first.product
      end

      # validate license quantity
      # input row: email/quantity
      def execute
        Spree::LicensedProduct.transaction do
          @rows.each do |row|
            create_distribution_license(row)
          end

          send_email_notifications
        end
        @rows.each do |row|
          Spree::LicensesManager::SingleLicenseDistributer.new(row[:email]).execute
          assign_admin_role_to_email(row[:email])
        end
      end

      def create_distribution_license(row)
        current_quantity = row[:quantity].to_i

        @licensed_products.each do |licensed_product|
          next  if licensed_product.quantity == 0
          break if current_quantity == 0

          quantity = (licensed_product.quantity >= current_quantity) ? current_quantity : licensed_product.quantity
          current_quantity -= quantity

          distribution = create_distribution({
            email:            row[:email],
            licensed_product: licensed_product,
            quantity:         quantity
          })

          create_license({
            email: row[:email],
            quantity: quantity,
            product_distribution: distribution,
            order_id: licensed_product.order_id
          })

          reduce_license_quantity(licensed_product, quantity)
        end

      end

      def create_distribution(attrs={})
        Spree::ProductDistribution.create({
          from_user:  @user,
          product: @product
        }.merge(attrs))
      end

      def create_license(attrs={})
        license_attrs = {
          product: @product
        }.merge(attrs)

        licensed_product = Spree::LicensedProduct.create(license_attrs)
        if licensed_product.quantity > 1 || Spree::LicensedProduct.exist_product_license_not_expire?(licensed_product)
          licensed_product.user.assign_school_admin_role if licensed_product.user
          licensed_product.update(can_be_distributed: true)
          SingleLicenseExtractor.new(licensed_product, false).execute
        end
        licensed_product
      end

      def reduce_license_quantity(licensed_product, quantity)
        licensed_product.update(quantity: (licensed_product.quantity-quantity))
      end

      def send_email_notifications
        @rows.each do |row|
          LicenseMailer.notify_distribution(
            school_admin: @user,
            product_name: @product.name,
            to_email: row[:email],
            quantity: row[:quantity]
          ).deliver_later
        end
      end

      def assign_admin_role_to_email(email)
        user = Spree::User.find_by(email: email)
        if user && Spree::LicensedProduct.where(user_id: user.id, can_be_distributed: true).exists?
          user.assign_school_admin_role
        end
      end

    end
  end
end
