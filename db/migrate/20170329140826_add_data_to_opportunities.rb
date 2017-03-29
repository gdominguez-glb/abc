class AddDataToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :data, :text
  end
end
