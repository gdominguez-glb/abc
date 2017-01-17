class Account::AdditionalInformationsController < Account::BaseController
  def edit
    @user = current_spree_user
  end

  def update
    current_spree_user.update(custom_field_values_attributes: params[:spree_user][:custom_field_values_attributes])
  end
end
