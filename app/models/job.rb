class Job < ActiveRecord::Base
  scope :displayable, ->{ where(display: true) }

  acts_as_list
end
