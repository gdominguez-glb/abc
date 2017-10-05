class AccountSalesAbility
  include CanCan::Ability

  def initialize(user)
    user ||= ::Spree::User.new

    if user.has_admin_role?
      can :manage, :all
    end

    if user.has_account_sales_role?
      can [:admin, :read], Spree::Order
      can [:admin, :read], Spree::User
    end
  end
end
