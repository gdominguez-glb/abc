class AddOpportunityIdSfToOpportunity < ActiveRecord::Migration
  def change
    add_column :opportunities, :opportunity_id_sf, :string
  end
end
