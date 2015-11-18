class Account::SettingsController < Account::BaseController
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

  def save_grade_option
    current_spree_user.settings[:grade_option] = params[:grade_option]
    render nothing: true
  end

  def ghost_login
    session[:ghost_login_user_id] = current_spree_user.id
    sign_in(:spree_user, current_spree_user.delegate_for_user, bypass: true)
    redirect_to account_root_path
  end

  def ghost_back
    user = Spree::User.find_by(id: (session[:ghost_login_user_id] || session[:ghost_login_admin_id]))
    if user
      reset_session
      sign_in(:spree_user, user, bypass: true)
      redirect_to account_root_path
    else
      redirect_to root_path
    end
  end

  private

  def user_params
    _params = params.require(:user).permit(
      :phone,
      :first_name,
      :last_name,
      :email,
      :password,
      :allow_communication,
      :title,
      :school_district_id,
      :heard_from,
      :interested_grade_level,
      school_district_attributes: [:name, :state_id, :place_type],
      interested_subjects: [],
    )
    if _params[:school_district_id].blank?
      _params.delete(:school_district_id)
    else
      _params.delete(:school_district_attributes)
    end
    _params
  end

  def valid_password?
    current_spree_user.valid_password?(params[:current_password])
  end
end
