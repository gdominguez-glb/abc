class TrainingTypeCategory < ActiveRecord::Base
  has_many :event_trainings

  validates_presence_of :title
end
