class TrainingTypeCategory < ActiveRecord::Base
  has_many :event_trainings

  validates_presence_of :title
  validates_presence_of :slug, if: ->(c) { !c.is_default? }

  def self.default_category
    TrainingTypeCategory.where(is_default: true).first
  end
end
