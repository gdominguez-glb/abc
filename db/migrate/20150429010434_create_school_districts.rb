class CreateSchoolDistricts < ActiveRecord::Migration
  def change
    create_table :school_districts do |t|
      t.string :name
      t.integer :state_id
      t.string :place_type

      t.timestamps null: false
    end
  end
end
