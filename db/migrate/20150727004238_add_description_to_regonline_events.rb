class AddDescriptionToRegonlineEvents < ActiveRecord::Migration
  def change
    add_column :regonline_events, :description, :text
  end
end
