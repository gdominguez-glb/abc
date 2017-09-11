class AccountSalesAbility
  include CanCan::Ability

  def initialize(user)
    if user.has_account_sales_role?
      can [:admin, :read], Spree::Order
      can [:admin, :read], Spree::User
    end
  end
end
