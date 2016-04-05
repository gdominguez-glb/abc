class AddDisplayToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :display, :boolean, default: false
  end
end
