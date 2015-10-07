module Displayable
  extend ActiveSupport::Concern

  included do
    scope :displayable, ->{ where(display: true) }
  end
end
