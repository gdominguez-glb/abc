class EventPage < ActiveRecord::Base
  include Displayable
  include Archiveable
  include Publishable
  publishable name: :description

  has_many :regonline_event_headers
  belongs_to :page

  enum event_page_type: { global: 0, curriculum: 1 }

  validates_presence_of :title, :slug
  validates_presence_of :page_id, if:  Proc.new { |ep| ep.curriculum? }

  def by_header
    headers = self.regonline_event_headers.order(:position).to_a
    et_no_mapped = self.events.displayable.sorted.where(regonline_event_header_id: nil)
    s = Struct.new(:name, :events).new(nil, et_no_mapped)
    headers.push(s)
    headers
  end

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
end
