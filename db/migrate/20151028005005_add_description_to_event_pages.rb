class AddDescriptionToEventPages < ActiveRecord::Migration
  def change
    add_column :event_pages, :description, :text
  end
end
