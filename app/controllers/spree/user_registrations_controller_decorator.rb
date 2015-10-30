Spree::UserRegistrationsController.class_eval do

  # override to remove flash message on sign up
  def create
    @user = build_resource(spree_user_params)
    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        if current_order
          current_order.associate_user! @user
        end
        sign_up(resource_name, resource)
        session[:spree_user_signup] = true
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords(resource)
      render :new
    end
  end

  private

  def spree_user_params
    new_params = params.require(:spree_user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :title, :school_id, :district_id, :allow_communication, school_district_attributes: [:name, :state_id, :place_type], interested_subjects: [])
    new_params[:school_district_id] = new_params[:school_id].blank? ? new_params[:district_id] : new_params[:school_id]
    if %w(Parent Homeschooler).member?(new_params[:title])
      new_params.delete(:school_district_id)
      name = "#{new_params[:first_name]} #{new_params[:last_name]}".strip
      new_params[:school_district_attributes][:name] = name
      new_params[:school_district_attributes][:place_type] = 'unaffiliated'
    elsif new_params[:school_district_id].blank?
      new_params.delete(:school_district_id)
    elsif new_params[:school_district_attributes][:name].blank?
      new_params.delete(:school_district_attributes)
    end
    new_params
  end
end
