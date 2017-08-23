module Spree
  module LicensesManager
    class CouponCodeLicenser

      attr_accessor :code, :user, :product_id, :grade_id, :school_name

      def initialize(opts={})
        @code       = Spree::CouponCode.find_by(code: opts[:code])
        @user       = opts[:user]
        @product_id = opts[:product_id]
        @grade_id   = opts[:grade_id]
        @school_name = opts[:school_name]
      end

      def code_available?
        @code && @code.available?
      end

      def already_activated?
        products_to_assign.map {|product|
          Spree::LicensedProduct.where(
            coupon_code_id: @code.id,
            product_id: product.id,
            user_id: @user.id
          ).exists?
        }.all?
      end

      def execute
        return { success: false, message: 'Product key not available' } if !code_available?
        return { success: false, message: 'No products to activate' } if products_to_assign.empty?
        return { success: false, message: 'Already activated the product key with this product' } if already_activated?

        common_attrs = { email: @user.email, user_id: @user.id, coupon_code: @code, quantity: 1, order: @code.order, school_name_from_coupon: @school_name }
        products_to_assign.each do |product|
          licensed_product = Spree::LicensedProduct.find_or_initialize_by({ product_id: product.id }.merge(common_attrs))
          if licensed_product.new_record?
            licensed_product.save
            if @code.old_coupon_code?
              @code.increase_used_quantity!
            else
              @code.coupon_code_products.find_by(product_id: product).try(:increase_used_quantity!)
            end
          end
        end
 
        return { success: true, message: 'Licenses activate successfully' }
      end

      def products_to_assign
        return @code.products.where(id: @product_id) if @product_id.present?
        return @code.products_of_grade(@grade_id) if @grade_id.present?
        []
      end

      def used_code_before?
        Spree::LicensedProduct.where(coupon_code_id: @code.id, user_id: @user.id).exists?
      end

    end
  end
end
