class AddGradesToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :grades, :text
  end
end
