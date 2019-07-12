class Account::SettingsController < Account::BaseController
  include CustomFieldValuesUpdatable
  include SchoolDistrictParamProcessor

  def index
    domain = current_spree_user.email.split('@')[1]
    @products_by_domain = Domain.products_by_domain(domain: domain,
                                                    admin: admin)

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

      assign_licenses if user_params[:licenses].present?

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
      ghost_back_path = session[:ghost_back_path] || account_root_path
      reset_session
      sign_in(:spree_user, user, bypass: true)
      redirect_to ghost_back_path
    else
      redirect_to root_path
    end
  end

  private

  def assign_licenses
    worker = LicensesDistributionWorker.new
    worker.perform(admin.id, licences_to_assign, [current_spree_user.email], '1')
  end

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
      :automatic_distribution,
      licenses: [],
      school_district_attributes: [:name, :country_id, :state_id, :city, :place_type],
      interested_subjects: []
    )
    process_school_district_param(_params)
    _params
  end

  def valid_password?
    current_spree_user.valid_password?(params[:current_password])
  end

  def licences_to_assign
    user_params[:licenses].reject { |l| l.empty? }
  end

  def admin
    Spree::User.where('email LIKE ?',
                      "%@#{current_spree_user.email.split('@')[1]}")
      .joins(:spree_roles).where("spree_roles.name = ?", 'admin').first
  end
end
