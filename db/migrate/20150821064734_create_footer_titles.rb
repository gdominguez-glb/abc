class CreateFooterTitles < ActiveRecord::Migration
  def change
    create_table :footer_titles do |t|
      t.string :title
      t.string :link
      t.integer :position, default: 0

      t.timestamps null: false
    end
  end
end
