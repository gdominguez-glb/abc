class CustomFieldOption < ActiveRecord::Base
  belongs_to :custom_field
  scope :sorted, -> { order(:position) }
end
