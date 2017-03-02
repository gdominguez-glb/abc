class CustomFieldOption < ActiveRecord::Base
  include Displayable

  belongs_to :custom_field
  scope :sorted, -> { order(:position) }
end
