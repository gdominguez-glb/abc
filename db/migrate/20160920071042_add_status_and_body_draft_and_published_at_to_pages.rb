class AddStatusAndBodyDraftAndPublishedAtToPages < ActiveRecord::Migration
  def change
    add_column :pages, :status, :integer
    add_column :pages, :body_draft, :text
    add_column :pages, :published_at, :datetime
  end
end
