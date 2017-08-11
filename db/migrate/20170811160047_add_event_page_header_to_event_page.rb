class AddEventPageHeaderToEventPage < ActiveRecord::Migration
  def change
    add_reference :regonline_events, :regonline_event_header, index: true
    add_foreign_key :regonline_events, :regonline_event_headers
  end
end
