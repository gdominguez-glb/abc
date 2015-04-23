class AddLicenseFieldsToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :license_length, :integer
    add_column :spree_products, :license_text, :text
  end
end
