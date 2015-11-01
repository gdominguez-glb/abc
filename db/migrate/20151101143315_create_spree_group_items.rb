class CreateSpreeGroupItems < ActiveRecord::Migration
  def change
    create_table :spree_group_items do |t|
      t.integer :group_id
      t.integer :product_id

      t.timestamps null: false
    end
  end
end
