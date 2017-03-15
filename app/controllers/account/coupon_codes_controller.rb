class Account::CouponCodesController < Account::BaseController

  def new
  end

  def activate
    @coupon_code = Spree::CouponCode.find_by(code: params[:code].upcase)
  end

  def activate_product
    params[:school_name] ||= ""

    @coupon_code = Spree::CouponCode.find_by(code: params[:id].upcase)
    @result = Spree::LicensesManager::CouponCodeLicenser.new(
      code: @coupon_code.code,
      user: current_spree_user,
      product_id: params[:product_id],
      school_name: params[:school_name]
    ).execute
  end
end
