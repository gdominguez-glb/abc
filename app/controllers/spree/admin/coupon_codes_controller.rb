class Spree::Admin::CouponCodesController < Spree::Admin::ResourceController
  before_action :process_schools_xls, only: [:create]

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
    @data = Spree::LicensedProduct.where(coupon_code_id: @coupon_code.id, product_id: @product.id).pluck(:email, :school_name_from_coupon)
  end

  def coupon_code_params
    _params = params.require(:coupon_code).permit(:total_quantity, :school_district_id, :product_ids, :code, :sync_specified_order, :sf_order_id)
    _params[:product_ids] = _params[:product_ids].split(',')
    _params[:school_lists] = params[:coupon_code][:school_lists] unless params[:coupon_code][:school_lists].nil?
    _params
  end

  private

  def process_schools_xls
    return if params[:coupon_code][:schools_xls].nil?

    file = File.new params[:coupon_code][:schools_xls].path
    roo = Roo::Spreadsheet.open(file)
    params[:coupon_code][:school_lists] = roo.to_a.flatten.drop(1)
  rescue
    params[:coupon_code][:school_lists] = []
  end
end
