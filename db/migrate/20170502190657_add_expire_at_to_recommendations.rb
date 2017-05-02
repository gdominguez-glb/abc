class AddExpireAtToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :expire_at, :datetime
  end
end
