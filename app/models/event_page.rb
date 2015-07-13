class EventPage < ActiveRecord::Base
  belongs_to :page

  scope :displayable, ->{ where(display: true) }
end
