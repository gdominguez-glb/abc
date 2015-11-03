class CreateLegacyUsers < ActiveRecord::Migration
  def change
    create_table :legacy_users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.boolean :is_school_admin, default: false
      t.boolean :is_sub_admin, default: false
      t.integer :parent_admin_id
      t.datetime :imported_at
      t.integer :ee_id

      t.timestamps null: false
    end
  end
end
