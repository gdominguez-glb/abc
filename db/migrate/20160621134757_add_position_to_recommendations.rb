class AddPositionToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :position, :integer, :default => 0
  end
end
