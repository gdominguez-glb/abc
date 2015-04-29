class AddSchoolDistrictIdToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :school_district_id, :integer
  end
end
