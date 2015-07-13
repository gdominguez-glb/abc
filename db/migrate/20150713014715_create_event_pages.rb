class CreateEventPages < ActiveRecord::Migration
  def change
    create_table :event_pages do |t|
      t.string :title
      t.integer :page_id
      t.boolean :display, default: false
      t.string :regonline_filter
      t.string :slug

      t.timestamps null: false
    end
  end
end
