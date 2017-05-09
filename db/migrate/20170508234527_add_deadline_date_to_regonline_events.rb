class AddDeadlineDateToRegonlineEvents < ActiveRecord::Migration
  def change
    add_column :regonline_events, :deadline_date, :date
  end
end
