class CustomFieldValue < ActiveRecord::Base
  belongs_to :custom_field
  belongs_to :user
end
