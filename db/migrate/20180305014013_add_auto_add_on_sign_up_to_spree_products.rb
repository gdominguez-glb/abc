class AddAutoAddOnSignUpToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :auto_add_on_sign_up, :boolean, default: false
  end
end
