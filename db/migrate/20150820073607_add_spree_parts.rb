class AddSpreeParts < ActiveRecord::Migration
  def change
    create_table :spree_parts do |t|
      t.integer :bundle_id, index: true, null: false
      t.integer :product_id, index: true, null: false
      t.timestamps
    end

    change_table :spree_products do |t|
      t.column :can_be_part, :boolean, default: false, null: false
      t.column :individual_sale, :boolean, default: true, null: false
    end
  end

  def up
    Spree::Product.update_all(individual_sale: true)
  end
end
