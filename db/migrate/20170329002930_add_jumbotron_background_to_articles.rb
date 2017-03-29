class AddJumbotronBackgroundToArticles < ActiveRecord::Migration
  def up
    add_attachment :articles, :jumbotron_background
  end

  def down
    remove_attachment :articles, :jumbotron_background
  end
end
