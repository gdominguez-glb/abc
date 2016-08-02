module Spree
  module LicensesManager
    class CouponCodeLicenser

      attr_accessor :code, :user, :product_id, :grade_id

      def initialize(opts={})
        @code       = Spree::CouponCode.find_by(code: opts[:code])
        @user       = opts[:user]
        @product_id = opts[:product_id]
        @grade_id   = opts[:grade_id]
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
        return { success: false, message: 'Code not available' } if !code_available?
        return { success: false, message: 'No products to activate' } if products_to_assign.empty?
        return { success: false, message: 'Already activated the code with the option.' } if already_activated?

        _used_code_before = used_code_before?

        common_attrs = { email: @user.email, user_id: @user.id, coupon_code: @code, quantity: 1 }
        products_to_assign.each do |product|
          Spree::LicensedProduct.find_or_create_by({ product_id: product.id }.merge(common_attrs))
        end

        code.increase_used_quantity! if !_used_code_before

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
