class CreateEventPageHeaders < ActiveRecord::Migration
  def change
    create_table :regonline_event_headers do |t|
      t.string :name
      t.integer :position
      t.references :event_page

      t.timestamps null: false
    end
  end
end
