class CustomFieldValue < ActiveRecord::Base
  belongs_to :custom_field
  belongs_to :user

  attr_accessor :values

  after_initialize :init_multiple_values
  before_save :handle_multiple_values

  scope :displayable, -> { joins(:custom_field).where(custom_fields: { display: true }) }

  def init_multiple_values
    self.values ||= (self.value || '').split(',')
  end

  def handle_multiple_values
    self.value = (self.values || []).reject(&:blank?).join(',') if self.custom_field.field_type == 'multiple_select'
  end
end
