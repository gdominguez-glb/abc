class AddSchoolNameFromCouponToSpreeLicensedProduct < ActiveRecord::Migration
  def change
    add_column :spree_licensed_products, :school_name_from_coupon, :string
  end
end
