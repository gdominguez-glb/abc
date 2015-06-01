class Question < ActiveRecord::Base
  has_one :answer
  scope :displayable, ->{ where(display: true) }
end
