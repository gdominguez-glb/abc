class RegonlineEventHeader < ApplicationRecord
  has_many :events, -> { order('start_date asc') }, class_name: "RegonlineEvent"
  belongs_to :event_page

  validates :name, presence: true
end
