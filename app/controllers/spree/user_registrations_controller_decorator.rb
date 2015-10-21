Spree::UserRegistrationsController.class_eval do

  private

  def spree_user_params
    new_params = params.require(:spree_user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :title, :school_id, :district_id, school_district_attributes: [:name, :state_id, :place_type], interested_subjects: [])
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
