class HelpItem < ApplicationRecord
  include Displayable

  validates_presence_of :title, :content
end
