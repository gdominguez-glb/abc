module Spree
  module Admin
    class CouponCodesController < ResourceController
      def index
        @coupon_codes = Spree::CouponCode.includes(:products).order('created_at desc').page(params[:page])
      end

      def create
        @coupon_code = Spree::CouponCode.new(coupon_code_params)
        if @coupon_code.save
          redirect_to admin_coupon_codes_path, notice: 'Coupon Code generated successfully.'
        else
          render :new
        end
      end

      def show
        @licenses_with_quantity = Spree::LicensedProduct.where(coupon_code_id: @coupon_code.id).select('product_id, count(*) product_quantity').group('product_id').includes(:product)
      end

      def coupon_code_params
        _params = params.require(:coupon_code).permit(:total_quantity, :school_district_id, :product_ids)
        _params[:product_ids] = _params[:product_ids].split(',')
        _params
      end
    end
  end
end
