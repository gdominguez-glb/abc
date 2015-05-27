class AccountController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_school_admin!, only: [:admin]

  def index
  end

  def settings
  end

  def profile
  end

  def favorites
    @favorite_products = current_spree_user.favorite_products.includes(:product)
  end

  def save_profile
    if spree_current_user.update(user_params)
      redirect_to '/account/settings', notice: "Saved profile successfully"
    else
      render :edit_profile
    end
  end

  private

  def user_params
    _params = params.require(:user).permit(:phone, :first_name, :last_name, :email, :password, :title, :school_district_id, school_district_attributes: [:name, :state_id, :place_type])
    if _params[:school_district_id].blank?
      _params.delete(:school_district_id)
    else
      _params.delete(:school_district_attributes)
    end
    _params
  end
end
