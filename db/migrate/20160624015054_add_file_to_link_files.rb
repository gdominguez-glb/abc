class AddFileToLinkFiles < ActiveRecord::Migration
  def up
    add_attachment :link_files, :file
  end

  def down
    remove_attachment :link_files, :file
  end
end
