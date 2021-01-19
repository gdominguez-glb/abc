class TrainingTypeCategory < ApplicationRecord
  has_many :event_trainings
  has_many :event_training_headers

  validates_presence_of :title
  validates_presence_of :slug, if: ->(c) { !c.is_default? }

  def self.default_category
    TrainingTypeCategory.where(is_default: true).first
  end

  def event_training_by_header
    event_headers = self.event_training_headers.order(:position).to_a
    et_no_mapped = self.event_trainings.order(:position).where(event_training_header_id: nil)
    s = Struct.new(:name, :event_trainings).new(nil, et_no_mapped)
    event_headers.push(s)
    event_headers
  end
end
