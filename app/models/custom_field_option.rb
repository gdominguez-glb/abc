class CustomFieldOption < ApplicationRecord
  include Displayable

  belongs_to :custom_field
  scope :sorted, -> { order(:position) }
end
