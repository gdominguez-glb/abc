class AddHubspotToPages < ActiveRecord::Migration
  def change
    add_column :pages, :hubspot, :boolean
  end
end
