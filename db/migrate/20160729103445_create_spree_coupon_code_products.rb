class CreateSpreeCouponCodeProducts < ActiveRecord::Migration
  def change
    create_table :spree_coupon_code_products do |t|
      t.integer :coupone_code_id
      t.integer :product_id

      t.timestamps null: false
    end
  end
end
