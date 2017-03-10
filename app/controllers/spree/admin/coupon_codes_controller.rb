module Spree
  module Admin
    class CouponCodesController < ResourceController
      def index
        @q = Spree::CouponCode.ransack(params[:q])
        @coupon_codes = @q.result.order('created_at desc').page(params[:page])
      end

      def create
        @coupon_code = Spree::CouponCode.new(coupon_code_params)
        if @coupon_code.save
          redirect_to admin_coupon_codes_path, notice: 'Product Key generated successfully.'
        else
          flash[:error] = @coupon_code.errors.full_messages.join(', ')
          render :new
        end
      end

      def show
        @licenses_with_quantity = Spree::LicensedProduct.where(coupon_code_id: @coupon_code.id).select('product_id, count(*) product_quantity').group('product_id').includes(:product)
      end

      def breakdown
        @coupon_code = Spree::CouponCode.find(params[:id])
        @product = @coupon_code.products.find(params[:product_id])
        @emails = Spree::LicensedProduct.where(coupon_code_id: @coupon_code.id, product_id: @product.id).pluck(:email)
      end

      def coupon_code_params
        _params = params.require(:coupon_code).permit(:total_quantity, :school_district_id, :product_ids, :code, :sync_specified_order, :sf_order_id)
        _params[:product_ids] = _params[:product_ids].split(',')
        _params
      end
    end
  end
end
