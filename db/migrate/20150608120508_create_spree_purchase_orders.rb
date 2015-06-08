class CreateSpreePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :spree_purchase_orders do |t|
      t.integer :payment_method_id
      t.integer :user_id
      t.string :po_number
      t.string :person_to_receive_license
      t.boolean :default, default: false, null: false

      t.timestamps null: false
    end
  end
end
