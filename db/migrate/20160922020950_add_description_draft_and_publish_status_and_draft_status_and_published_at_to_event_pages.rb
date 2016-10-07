class AddDescriptionDraftAndPublishStatusAndDraftStatusAndPublishedAtToEventPages < ActiveRecord::Migration
  def change
    add_column :event_pages, :description_draft, :text
    add_column :event_pages, :publish_status, :integer, default: 0
    add_column :event_pages, :draft_status, :integer, default: 0
    add_column :event_pages, :published_at, :datetime
  end
end
