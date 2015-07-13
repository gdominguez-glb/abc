class EventPage < ActiveRecord::Base
  belongs_to :page

  scope :displayable, ->{ where(display: true) }

  def events
    RegonlineEvent.with_filter(self.regonline_filter)
  end
end
