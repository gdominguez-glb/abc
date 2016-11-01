class AddViewsAndClicksToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :views, :integer, default: 0
    add_column :recommendations, :clicks, :integer, default: 0
  end
end
