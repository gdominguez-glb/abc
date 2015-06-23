class CreateRegonlineEvents < ActiveRecord::Migration
  def change
    create_table :regonline_events do |t|
      t.string :regonline_id
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :active_date
      t.string :city
      t.string :state
      t.string :country
      t.string :postal_code
      t.string :location_name
      t.string :location_room
      t.string :location_address1
      t.string :location_address2
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.timestamps null: false
    end
  end
end
