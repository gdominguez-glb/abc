class Question < ActiveRecord::Base
  belongs_to :faq_category

  has_one :answer

  scope :displayable, ->{ where(display: true) }

  accepts_nested_attributes_for :answer

  validates_presence_of :title, :faq_category
end
