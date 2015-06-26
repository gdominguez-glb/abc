class AddEmailToSpreeLicensedProducts < ActiveRecord::Migration
  def change
    add_column :spree_licensed_products, :email, :string
  end
end
