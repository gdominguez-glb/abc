class AddTargetToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :call_to_action_button_target, :string
  end
end
