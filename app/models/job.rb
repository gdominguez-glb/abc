class Job < ActiveRecord::Base
  scope :displayable, ->{ where(display: true) }
end
