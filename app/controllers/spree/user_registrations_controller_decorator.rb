Spree::UserRegistrationsController.class_eval do

  include SchoolDistrictParamProcessor

  # override to remove flash message on sign up
  def create
    @user = build_resource(spree_user_params)
    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        current_order.associate_user! @user if current_order

        sign_up(resource_name, resource)
        SignUpNotifier.delay.notify(@user.id)
        session[:spree_user_signup] = true
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords(resource)
      resource.school_district = nil if resource.school_district_id.present?
      render :new
    end
  end

  private

  def after_sign_up_path_for(resource_or_scope)
    main_app.display_terms_path
  end

  def spree_user_params
    new_params = params.require(:spree_user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      :title,
      :school_id,
      :district_id,
      :allow_communication,
      :phone,
      school_district_attributes: [:name, :state_id, :country_id, :city, :place_type],
      interested_subjects: []
    )
    process_school_district_param(new_params)
    new_params
  end
end
