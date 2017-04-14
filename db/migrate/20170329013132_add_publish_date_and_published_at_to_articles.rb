class AddPublishDateAndPublishedAtToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :publish_date, :date
    add_column :articles, :published_at, :datetime
  end
end
