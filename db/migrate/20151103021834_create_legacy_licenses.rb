class CreateLegacyLicenses < ActiveRecord::Migration
  def change
    create_table :legacy_licenses do |t|
      t.integer :user_id
      t.integer :product_id
      t.datetime :expiration_date
      t.integer :ee_id
      t.string :mapped_name

      t.timestamps null: false
    end
  end
end
