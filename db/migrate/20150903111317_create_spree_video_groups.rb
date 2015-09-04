class CreateSpreeVideoGroups < ActiveRecord::Migration
  def change
    create_table :spree_video_groups do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
