class AddSchoolListsToSpreeCouponCodes < ActiveRecord::Migration
  def change
    add_column :spree_coupon_codes, :school_lists, :text
  end
end
