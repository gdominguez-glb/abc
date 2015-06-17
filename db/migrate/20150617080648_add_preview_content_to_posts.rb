class AddPreviewContentToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :preview_content, :text
  end
end
