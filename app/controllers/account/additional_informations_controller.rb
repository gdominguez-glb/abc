class Account::AdditionalInformationsController < Account::BaseController
  include CustomFieldValuesUpdatable

  def edit
    @user = current_spree_user
  end

  def update
    update_custom_field_values(spree_current_user)
  end
end
