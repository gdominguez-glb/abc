class AddTourShowedLicensesToSpreeUsers < ActiveRecord::Migration
  def change
    rename_column :spree_users, :tour_showed, :tour_showed_dashboard
    add_column :spree_users, :tour_showed_licenses, :boolean, default: false
  end
end
