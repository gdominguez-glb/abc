class Spree::Admin::CouponCodesController < Spree::Admin::ResourceController
  before_action :process_schools_xls, only: [:create]
  before_action :set_payment_methods, only: [:new, :create]
  before_action :find_coupon_code, only: [:breakdown, :edit_code, :update_code]

  def index
    @q = Spree::CouponCode.ransack(params[:q])
    @coupon_codes = @q.result.order('created_at desc').page(params[:page])
  end

  def new
    @admin_new_coupon_code_form = AdminNewCouponCodeForm.new
    @order = Spree::Order.new
  end

  def create
    @admin_new_coupon_code_form = AdminNewCouponCodeForm.new(coupon_code_params.merge(
                                                              payment_source_params: params[:payment_source]
                                                            ))
    @order = Spree::Order.new
    if @admin_new_coupon_code_form.perform
      redirect_to admin_coupon_codes_path, notice: 'Product Key generated successfully.'
    else
      flash[:error] = @admin_new_coupon_code_form.coupon_code.errors.full_messages.join(', ')
      render :new
    end
  end

  def show
    @licenses_with_quantity = Spree::LicensedProduct.where(coupon_code_id: @coupon_code.id).select('product_id, count(*) product_quantity').group('product_id').includes(:product)
  end

  def breakdown
    @product = @coupon_code.products.find(params[:product_id])
    @data = Spree::LicensedProduct.where(coupon_code_id: @coupon_code.id, product_id: @product.id).pluck(:email, :school_name_from_coupon)
  end

  def edit_code
  end

  def update_code
  end

  def coupon_code_params
    _params = params.require(:coupon_code).permit(:total_quantity, :school_district_id, :product_ids, :code, :sync_specified_order, :sf_order_id, :admin_email, :amount, :payment_method_id, :payment_source)
    _params[:school_lists] = params[:coupon_code][:school_lists].blank? ? [] : params[:coupon_code][:school_lists]
    _params
  end

  private

  def find_coupon_code
    @coupon_code = Spree::CouponCode.find(params[:id])
  end

  def process_schools_xls
    return if params[:coupon_code][:schools_xls].nil?

    file = File.new params[:coupon_code][:schools_xls].path
    roo = Roo::Spreadsheet.open(file)
    params[:coupon_code][:school_lists] = roo.to_a.flatten.drop(1)
  rescue
    params[:coupon_code][:school_lists] = []
  end

  def set_payment_methods
    @payment_methods = Spree::PaymentMethod.where(name: ['Purchase Order', 'Credit Card']).available(:back_end)
  end
end
