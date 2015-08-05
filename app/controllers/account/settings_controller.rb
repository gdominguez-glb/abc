class Account::SettingsController < Account::BaseController
  before_action :load_settings, only: [:index, :save_profile]

  def index
  end

  def save_profile
    if user_params[:password].present? && !valid_password?
      flash.now[:error] = 'You must enter valid current password.'
      render :index and return
    end
    if spree_current_user.update(user_params)
      sign_in(:spree_user, spree_current_user, bypass: true)
      redirect_to '/account/settings', notice: "Saved profile successfully"
    else
      render :index
    end
  end

  def save_email_notifications
    spree_current_user.settings[:email_notifications] = email_notifications_params.symbolize_keys
    redirect_to '/account/settings', notice: "Updated email notification successfully"
  end

  def save_grade_option
    current_spree_user.settings[:grade_option] = params[:grade_option]
    render nothing: true
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

  def load_settings
    @email_notifications = spree_current_user.email_notifications

    @profile_fields = (if spree_current_user.has_spree_role?('admin')
                        AppSettings.user_profile_settings[:admin]
                      elsif spree_current_user.has_spree_role?('school admin')
                        AppSettings.user_profile_settings[:school_district_admin]
                      else
                        AppSettings.user_profile_settings[:user]
                      end || {}).keys
  end

  def valid_password?
    current_spree_user.valid_password?(params[:current_password])
  end
end
