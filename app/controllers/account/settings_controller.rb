class Account::SettingsController < Account::BaseController
  include CustomFieldValuesUpdatable
  include SchoolDistrictParamProcessor

  def index
    if current_spree_user.school_district
      if current_spree_user.school_district.school?
        current_spree_user.school_id = current_spree_user.school_district.id
      elsif current_spree_user.school_district.district?
        current_spree_user.district_id = current_spree_user.school_district.id
      end
    end
  end

  def save_profile
    if user_params[:password].present? && !valid_password?
      flash.now[:error] = 'You must enter valid current password.'
      render :index and return
    end
    if spree_current_user.update(user_params)
      update_custom_field_values(spree_current_user) if $flipper[:expanding_user_profiles].enabled?
      sign_in(:spree_user, spree_current_user, bypass: true)
      redirect_to '/account/settings', notice: "Saved profile successfully"
    else
      render :index
    end
  end

  def save_grade_option
    current_spree_user.settings[:grade_option] = params[:grade_option]
    render body: nil
  end

  def ghost_login
    session[:ghost_login_user_id] = current_spree_user.id
    sign_in(:spree_user, current_spree_user.delegate_for_user, bypass: true)
    redirect_to account_root_path
  end

  def ghost_back
    user = Spree::User.find_by(id: (session[:ghost_login_user_id] || session[:ghost_login_admin_id]))
    if user
      ghost_back_path = session[:ghost_back_path] || account_root_path
      reset_session
      sign_in(:spree_user, user, bypass: true)
      redirect_to ghost_back_path
    else
      redirect_to root_path
    end
  end

  private

  def user_params
    _params = params.require(:spree_user).permit(
      :phone,
      :first_name,
      :last_name,
      :email,
      :password,
      :title,
      :manual_title,
      :school_district_id,
      :heard_from,
      :interested_grade_level,
      :school_id,
      :district_id,
      :phone,
      :zip_code,
      school_district_attributes: [:name, :country_id, :state_id, :city, :place_type],
      interested_subjects: []
    )
    process_school_district_param(_params)
    _params
  end

  def valid_password?
    current_spree_user.valid_password?(params[:current_password])
  end
end
