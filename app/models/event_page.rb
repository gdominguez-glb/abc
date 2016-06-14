class EventPage < ActiveRecord::Base
  include Displayable

  belongs_to :page

  enum event_page_type: { global: 0, curriculum: 1 }

  validates_presence_of :title, :slug
  validates_presence_of :page_id, if:  Proc.new { |ep| ep.curriculum? }

  def events
    RegonlineEvent.with_filter(self.regonline_filter)
  end

  searchkick callbacks: :async

  def should_index?
    self.display?
  end

  def search_data
    {
      title: title,
      description: description,
      user_ids: [-1]
    }
  end
end
