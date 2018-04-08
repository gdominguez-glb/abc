class AddFreeDeletableToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :free_deletable, :boolean, default: false
  end
end
