class AddPhotoColumnsToRecommendations < ActiveRecord::Migration
  def up
    add_attachment :recommendations, :photo
  end

  def down
    remove_attachment :recommendations, :photo
  end
end
