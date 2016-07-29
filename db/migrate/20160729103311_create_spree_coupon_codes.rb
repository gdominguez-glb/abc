class CreateSpreeCouponCodes < ActiveRecord::Migration
  def change
    create_table :spree_coupon_codes do |t|
      t.string :code
      t.integer :total_quantity
      t.integer :used_quantity

      t.timestamps null: false
    end
  end
end
