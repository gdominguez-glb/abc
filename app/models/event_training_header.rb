class EventTrainingHeader < ActiveRecord::Base
  belongs_to :training_type_category
  has_many :event_trainings, -> { order("position") }

  validates :name, presence: true
end
