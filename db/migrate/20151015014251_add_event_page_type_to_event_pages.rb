class AddEventPageTypeToEventPages < ActiveRecord::Migration
  def change
    add_column :event_pages, :event_page_type, :integer, default: 0
  end
end
