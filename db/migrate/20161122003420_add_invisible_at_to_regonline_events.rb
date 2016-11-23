class AddInvisibleAtToRegonlineEvents < ActiveRecord::Migration
  def change
    add_column :regonline_events, :invisible_at, :date
  end
end
