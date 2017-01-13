class AddCityStateToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :city, :string, default: ''
    add_column :spree_users, :state, :string, default: ''
  end
end
