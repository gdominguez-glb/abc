class AddUserTitleToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :user_title, :string
  end
end
