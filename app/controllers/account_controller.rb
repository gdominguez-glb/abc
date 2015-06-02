class AccountController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_school_admin!, only: [:admin]

  def index
    @nav_name = 'My Products'
  end

  def settings
    @email_notifications = spree_current_user.email_notifications

    @profile_fields = (if spree_current_user.has_spree_role?('admin')
                        AppSettings.user_profile_settings[:admin]
                      elsif spree_current_user.has_spree_role?('school admin')
                        AppSettings.user_profile_settings[:school_district_admin]
                      else
                        AppSettings.user_profile_settings[:user]
                      end || {}).keys
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
    spree_current_user.settings[:email_notifications] = email_notifications_params.symbolize_keys
    redirect_to '/account/settings', notice: "Updated email notification successfully"
  end

  def help
    @qa = Question.displayable
  end

  def help_qa
    @question = Question.find(params[:id])
  end

  private

  def user_params
    _params = params.require(:user).permit(
      :phone,
      :first_name,
      :last_name,
      :email,
      :password,
      :title,
      :school_district_id,
      :heard_from,
      :interested_subject,
      :interested_grade_level,
      school_district_attributes: [:name, :state_id, :place_type]
    )
    if _params[:school_district_id].blank?
      _params.delete(:school_district_id)
    else
      _params.delete(:school_district_attributes)
    end
    _params
  end

  def email_notifications_params
    _params = params.permit(
      :professional_development,
      :special_offers_and_products,
      :revision_updates,
      :phone_communication,
      :email_communication
    )
    _params.each do |key, value|
      _params[key] = (value == 'true' ? true : false)
    end
    _params
  end
end
