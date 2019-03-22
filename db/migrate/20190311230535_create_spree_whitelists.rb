class CreateSpreeWhitelists < ActiveRecord::Migration
  def change
    create_table :spree_whitelists do |t|
      t.references :school_district, index: true

      t.timestamps null: false
    end

    add_foreign_key :spree_whitelists, :school_districts
  end
end
