class Account::RootController < Account::BaseController
  def index
    if current_spree_user.has_school_admin_role? && current_spree_user.has_more_than_3_products?
      redirect_to account_licenses_path
    else
      redirect_to account_products_path
    end
  end
end
