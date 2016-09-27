class EventPage < ActiveRecord::Base
  include Displayable

  belongs_to :page

  enum event_page_type: { global: 0, curriculum: 1 }

  enum publish_status: [ :pending, :published ]
  enum draft_status: [ :draft, :draft_in_progress, :draft_published ]

  scope :archived, -> { where(archived: true) }
  scope :unarchive, -> { where(archived: false) }

  validates_presence_of :title, :slug
  validates_presence_of :page_id, if:  Proc.new { |ep| ep.curriculum? }

  def events
    RegonlineEvent.with_filter(self.regonline_filter)
  end

  searchkick callbacks: :async

  def should_index?
    self.display?
  end

  def events_text
    events.map(&:text_to_index).join(',')
  end

  def search_data
    {
      title: title,
      feature: 'events',
      description: description,
      events_text: events_text,
      user_ids: [-1]
    }
  end

  def publish!
    self.update(published_at: Time.now, description: self.description_draft, publish_status: :published, draft_status: :draft_published)
  end

  def archive!
    self.update(archived: true, archived_at: Time.now)
  end
end
