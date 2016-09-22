class AddContentDraftAndPublishStatusAndDraftStatusAndPublishedAtToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :content_draft, :text
    add_column :jobs, :publish_status, :integer, default: 0
    add_column :jobs, :draft_status, :integer, default: 0
    add_column :jobs, :published_at, :datetime
  end
end
