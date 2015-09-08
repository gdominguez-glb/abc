class AddCanBeDistributedToSpreeLicensedProducts < ActiveRecord::Migration
  def change
    add_column :spree_licensed_products, :can_be_distributed, :boolean, default: false
  end

  def up
    Spree::LicensedProduct.where("quantity > 0").update(can_be_distributed: true)
  end
end
