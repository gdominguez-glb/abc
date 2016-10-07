class HelpItem < ActiveRecord::Base
  include Displayable

  validates_presence_of :title, :content
end
