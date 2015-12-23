class EventPage < ActiveRecord::Base
  include Displayable

  belongs_to :page

  enum event_page_type: { global: 0, curriculum: 1 }

  validates_presence_of :title, :slug
  validates_presence_of :page_id, if:  Proc.new { |ep| ep.curriculum? }

  def events
    RegonlineEvent.with_filter(self.regonline_filter)
  end
end
