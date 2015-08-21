class CreateFooterLinks < ActiveRecord::Migration
  def change
    create_table :footer_links do |t|
      t.integer :footer_title_id
      t.string :name
      t.string :link
      t.integer :position, default: 0

      t.timestamps null: false
    end
  end
end
