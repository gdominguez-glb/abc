class FaqCategory < ApplicationRecord
  include Displayable

  validates_presence_of :name

  has_many :questions

  acts_as_list
end
