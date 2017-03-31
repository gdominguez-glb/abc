class AddJumbotronBackgroundToBlogs < ActiveRecord::Migration
  def up
    add_attachment :blogs, :jumbotron_background
  end

  def down
    remove_attachment :blogs, :jumbotron_background
  end
end
