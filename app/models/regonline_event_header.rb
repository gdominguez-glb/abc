class RegonlineEventHeader < ActiveRecord::Base
  has_many :regonline_events, -> { order("position") }
  belongs_to :event_page

  validates :name, presence: true
end
