class AddHideDropdownToEventPages < ActiveRecord::Migration
  def change
    add_column :event_pages, :hide_dropdown, :boolean, default: false
  end
end
