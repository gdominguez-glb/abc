class CustomField < ActiveRecord::Base
  include Displayable

  FIELD_TYPES = ['select', 'multiple_select', 'text'].freeze

  validates_presence_of :name, :description, :salesforce_field_name

  acts_as_list

  has_many :custom_field_options
  accepts_nested_attributes_for :custom_field_options, allow_destroy: true
end
