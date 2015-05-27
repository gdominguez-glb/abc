class AccountController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_school_admin!, only: [:admin]

  def index
  end

  def settings
    @email_notifications = spree_current_user.settings(:email_notifications)
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

  def save_email_notifications
    spree_current_user.settings(:email_notifications).update_attributes!(email_notifications_params)
    redirect_to '/account/settings', notice: "Updated email notification successfully"
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

  def email_notifications_params
    _params = params.permit(:professional_development, :special_offers_and_products, :revision_updates, :phone_communication, :email_communication)
    _params.each do |key, value|
      _params[key] = (value == 'true' ? true : false)
    end
    _params
  end
end
