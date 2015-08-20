class HelpItem < ActiveRecord::Base
  scope :displayable, ->{ where(display: true) }

  validates_presence_of :title, :content
end
