class Ability
  include CanCan::Ability

  def initialize(user)
    # direct permissions
     # can :create, SomeRailsObject

     # or permissions by group
     if spree_user.has_spree_role? "admin"
       # can :create, SomeRailsAdminObject
     end
   end
  end
end
