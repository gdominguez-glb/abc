class Ability
  include CanCan::Ability

  def initialize(user)
    # direct permissions
    # can :create, SomeRailsObject

    # or permissions by group
    if user.admin?
      # can :create, SomeRailsAdminObject
    end
  end
end
