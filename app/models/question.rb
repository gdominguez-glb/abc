class Question < ActiveRecord::Base
  has_one :answer
  scope :displayable, ->{ where(display: true) }
  accepts_nested_attributes_for :answer

  validates_presence_of :title
end
