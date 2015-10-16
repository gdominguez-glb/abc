class AddDownloadUrlAndGradeBandsAndSessionTypesAndDisplayToRegonlineEvents < ActiveRecord::Migration
  def change
    add_column :regonline_events, :download_url, :string
    add_column :regonline_events, :grade_bands, :string
    add_column :regonline_events, :session_types, :text
    add_column :regonline_events, :display, :boolean, default: false
  end
end
