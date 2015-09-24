Spree::UserRegistrationsController.class_eval do
  def after_sign_in_path_for(resource)
    if resource
      if !resource.admin?
        return_to = session["spree_user_return_to"]
        session["spree_user_return_to"] = nil

        return_to || '/store'
      else
        '/store/admin'
      end
    end
  end

  def after_sign_up_path_for(resource)
    '/account'
  end

  private

  def spree_user_params
    _params = params.require(:spree_user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :title, :school_id, :district_id, school_district_attributes: [:name, :state_id, :place_type], interested_subjects: [])
    _params[:school_district_id] = _params[:school_id].blank? ? _params[:district_id] : _params[:school_id]
    if _params[:school_district_id].blank?
      _params.delete(:school_district_id)
    elsif _params[:school_district_attributes][:name].blank?
      _params.delete(:school_district_attributes)
    end
    _params
  end
end
