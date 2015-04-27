class CmsAbility
  include CanCan::Ability

  # This ability is for CMS permission control
  def initialize(user)
    # direct permissions
    # can :create, SomeRailsObject

    # or permissions by group
    if user.admin?
      # can :create, SomeRailsAdminObject
    end
  end
end
