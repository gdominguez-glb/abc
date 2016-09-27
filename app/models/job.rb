class Job < ActiveRecord::Base
  scope :displayable, ->{ where(display: true) }

  enum publish_status: [ :pending, :published ]
  enum draft_status: [ :draft, :draft_in_progress, :draft_published ]

  scope :archived, -> { where(archived: true) }
  scope :unarchive, -> { where(archived: false) }

  acts_as_list

  searchkick callbacks: :async, personalize: "user_ids"

  def publish!
    self.update(published_at: Time.now, content: self.content_draft, publish_status: :published, draft_status: :draft_published)
  end

  def archive!
    self.update(archived: true, archived_at: Time.now)
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
