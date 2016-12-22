module Displayable
  extend ActiveSupport::Concern

  included do
    scope :displayable, -> { where(display: true) }
    scope :displayable_random, -> { where(display:true).order("RANDOM()") }
  end
end
