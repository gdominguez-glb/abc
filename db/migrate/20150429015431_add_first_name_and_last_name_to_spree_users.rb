class AddFirstNameAndLastNameToSpreeUsers < ActiveRecord::Migration
  def up
    add_column :spree_users, :first_name, :string
    add_column :spree_users, :last_name, :string

    remove_column :spree_users, :name
  end

  def down
    add_column :spree_users, :name, :string

    remove_column :spree_users, :first_name
    remove_column :spree_users, :last_name
  end
end
