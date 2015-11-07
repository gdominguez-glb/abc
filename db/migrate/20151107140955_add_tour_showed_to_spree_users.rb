class AddTourShowedToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :tour_showed, :boolean, default: false
  end
end
