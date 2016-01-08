class AddTourShowedLicensesUsersToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :tour_showed_licenses_users, :boolean, default: false
  end
end
