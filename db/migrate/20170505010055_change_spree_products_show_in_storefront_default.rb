class ChangeSpreeProductsShowInStorefrontDefault < ActiveRecord::Migration
  def change
    change_column_default(:spree_products, :show_in_storefront, false)
  end
end
