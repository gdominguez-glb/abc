class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :name
      t.references :school_district, index: true

      t.timestamps null: false
    end
    add_foreign_key :domains, :school_districts
  end
end
