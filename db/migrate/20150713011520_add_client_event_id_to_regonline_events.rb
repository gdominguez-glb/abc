class AddClientEventIdToRegonlineEvents < ActiveRecord::Migration
  def change
    add_column :regonline_events, :client_event_id, :string
  end
end
