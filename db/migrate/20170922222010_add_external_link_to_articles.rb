class AddExternalLinkToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :external_link, :string
  end
end
