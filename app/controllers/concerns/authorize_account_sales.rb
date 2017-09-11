module AuthorizeAccountSales
  extend ActiveSupport::Concern

  def current_ability
    @current_ability = AccountSalesAbility.new(current_spree_user)
  end
end