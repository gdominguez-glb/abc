class AddIconToRecommendations < ActiveRecord::Migration
  def up
    remove_attachment :recommendations, :photo

    add_column :recommendations, :icon, :string
  end

  def down
    add_attachment :recommendations, :photo

    remove_column :recommendations, :icon
  end
end
