class FaqCategory < ActiveRecord::Base
  validates_presence_of :name

  has_many :questions

  acts_as_list
end
