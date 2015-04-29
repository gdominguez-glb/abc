Spree::UserRegistrationsController.class_eval do
  private
    def spree_user_params
      _params = params.require(:spree_user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :school_district_id, school_district_attributes: [:name, :state_id, :place_type])
      if _params[:school_district_id].blank?
        _params.delete(:school_district_id)
      else
        _params.delete(:school_district_attributes)
      end
      _params
    end
end
