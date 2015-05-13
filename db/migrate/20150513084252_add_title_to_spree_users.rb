class AddTitleToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :title, :string
  end
end
