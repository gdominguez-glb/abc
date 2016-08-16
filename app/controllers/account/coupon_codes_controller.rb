class Account::CouponCodesController < Account::BaseController

  def new
  end

  def activate
    @coupon_code = Spree::CouponCode.find_by(code: params[:code])
  end

  def activate_product
    @coupon_code = Spree::CouponCode.find_by(code: params[:id])
    @result = Spree::LicensesManager::CouponCodeLicenser.new(
      code: @coupon_code.code,
      user: current_spree_user,
      product_id: params[:product_id]
    ).execute
  end
end