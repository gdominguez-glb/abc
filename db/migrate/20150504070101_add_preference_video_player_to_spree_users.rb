class AddPreferenceVideoPlayerToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :preference_video_player, :string
  end
end
