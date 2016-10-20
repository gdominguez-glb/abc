class AddPublishStatusAndDraftStatusAndPublishedAtAndBodyDraftToPages < ActiveRecord::Migration
  def change
    add_column :pages, :publish_status, :integer, default: 0
    add_column :pages, :draft_status, :integer, default: 0
    add_column :pages, :published_at, :datetime
    add_column :pages, :body_draft, :text
  end
end
