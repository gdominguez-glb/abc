class FaqCategory < ActiveRecord::Base
  validates_presence_of :name

  has_many :questions

  scope :displayable, -> { where(display: true) }

  acts_as_list
end
