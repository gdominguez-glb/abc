class AddPublishStatusAndDraftStatusAndPublishedAtToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :publish_status, :integer, default: 0
    add_column :questions, :draft_status, :integer, default: 0
    add_column :questions, :published_at, :datetime

    add_column :answers, :content_draft, :text
  end
end
