class Spree::CsrAbility
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_csr_role?
      can :admin, Spree.user_class
      can [:index, :read, :edit], Spree.user_class

      can :admin, Spree::Order
      can [:index, :read, :edit], Spree::Order
    end
  end
end
