class Job < ActiveRecord::Base
  include Archiveable

  scope :displayable, ->{ where(display: true) }

  enum publish_status: [ :pending, :published ]
  enum draft_status: [ :draft, :draft_in_progress, :draft_published ]

  acts_as_list

  searchkick callbacks: :async, personalize: "user_ids"

  def publish!
    self.update(published_at: Time.now, content: self.content_draft, publish_status: :published, draft_status: :draft_published)
  end

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

end
