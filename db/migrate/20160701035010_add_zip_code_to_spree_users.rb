class AddZipCodeToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :zip_code, :string
  end
end
