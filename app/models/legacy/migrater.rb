class Legacy::Migrater
  def initialize(user)
    @user = user
    @legacy_user = Legacy::User.find_by(email: @user.email)
  end

  def execute
    return unless @legacy_user
    associate_school_admin
    assign_sub_admin
    associate_parent_admin
    assign_licenses
  end

  def assign_sub_admin
    if @legacy_user.is_school_admin?
      emails_to_update = Legacy::User.where(parent_admin_id: @legacy_user.id, is_sub_admin: true).pluck(:email)
      Spree::User.where(email: emails_to_update).update_all(delegate_user_id: @user.id)
    end
  end

  def associate_parent_admin
    if @legacy_user.is_sub_admin?
      legacy_parent_admin = Legacy::User.find_by(id: @legacy_user.parent_id)
      admin_user          = Spree::User.find_by(email: legacy_parent_adminemail)
      @user.update(delegate_user_id: admin_user.id) if admin_user
    end
  end

  def associate_school_admin
    if @legacy_user.is_school_admin?
      @user.assign_school_admin_role
    end
  end

  def assign_licenses
    @legacy_user.licenses.select('distinct (mapped_name) as mapped_name, expiration_date').order("expiration_date desc").map do |legacy_license|
      product = Spree::Product.find_by(name: legacy_license.mapped_name)
      if product
        Spree::LicensedProduct.create({
          product: product,
          user: @user,
          quantity: 1,
          expire_at: legacy_license.expiration_date,
          fulfillment_at: Time.now
        })
      end
    end
  end
end
