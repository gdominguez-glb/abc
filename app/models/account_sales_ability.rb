class AccountSalesAbility
  include CanCan::Ability

  def initialize(user)
    if user.has_admin_role?
      can :manage, :all
    end

    if user.has_account_sales_role?
      can :manage, Spree::Order
      can :manage, Spree::User
    end
  end
end
