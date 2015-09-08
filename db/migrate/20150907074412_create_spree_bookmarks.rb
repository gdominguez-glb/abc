class CreateSpreeBookmarks < ActiveRecord::Migration
  def change
    create_table :spree_bookmarks do |t|
      t.integer :user_id
      t.integer :bookmarkable_id
      t.string :bookmarkable_type

      t.timestamps null: false
    end
  end
end
