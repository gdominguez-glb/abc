class AccountSalesAbility
  include CanCan::Ability

  def initialize(user)
    user ||= ::Spree::User.new

    if user.has_admin_role?
      can :manage, :all
    end

    if user.has_account_sales_role?
      can :manage, Spree::Order
      can :manage, Spree::User
      can :manage, Spree::LicensedProduct
    end
  end
end