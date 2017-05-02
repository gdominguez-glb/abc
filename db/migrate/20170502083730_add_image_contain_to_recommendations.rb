class AddImageContainToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :image_contain, :boolean
  end
end
