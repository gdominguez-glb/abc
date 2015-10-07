class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.string :name
      t.text :description
      t.integer :position, default: 0

      t.timestamps null: false
    end
  end
end
