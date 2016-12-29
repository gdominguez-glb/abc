class AddImageToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :image_url, :text, after: :icon
  end
end
