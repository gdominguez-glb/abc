module UserRolable
  extend ActiveSupport::Concern

  def assign_user_role
    spree_roles << Spree::Role.user
  end

  def assign_school_admin_role
    if !has_school_admin_role?
      spree_roles << Spree::Role.school_admin
    end
  end

  def has_school_admin_role?
    spree_roles.where(id: Spree::Role.school_admin.id).count > 0
  end

  def has_admin_role?
    spree_roles.where(id: Spree::Role.admin.id).count > 0
  end

  def has_csr_role?
    spree_roles.where(id: Spree::Role.csr.id).count > 0
  end

  def has_vanity_admin_role?
    spree_roles.where(id: Spree::Role.vanity_admin.id).count > 0
  end

  def has_hr_role?
    spree_roles.where(id: Spree::Role.hr.id).count > 0
  end

  def can_see_cms?
    has_admin_role? || has_vanity_admin_role? || has_hr_role?
  end
end