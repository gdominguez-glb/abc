class Question < ApplicationRecord
  include Archiveable
  include Displayable
  include Publishable

  include FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :faq_category

  has_one :answer

  delegate :content, to: :answer, allow_nil: true

  accepts_nested_attributes_for :answer

  validates_presence_of :title, :faq_category

  searchkick callbacks: :async

  def should_index?
    display?
  end

  def search_data
    {
      title: title,
      content: content,
      user_ids: [-1]
    }
  end

  def publish!
    self.update(published_at: Time.now, publish_status: :published, draft_status: :draft_published)
    self.answer.update(content: self.answer.content_draft)
  end
end
