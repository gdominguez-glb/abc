class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.string :name
      t.string :title
      t.text :description
      t.integer :position, default: 0
      t.boolean :display, default: false

      t.timestamps null: false
    end
  end
end
