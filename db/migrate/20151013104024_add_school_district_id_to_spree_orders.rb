class AddSchoolDistrictIdToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :school_district_id, :integer
  end
end
