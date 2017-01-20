class CustomField < ActiveRecord::Base
  include Displayable

  FIELD_TYPES = ['short_text', 'long_text', 'select', 'multiple_select'].freeze

  validates_presence_of :name, :description, :salesforce_field_name

  acts_as_list

  attr_accessor :subjects, :user_titles

  after_initialize :set_subjects_and_user_titles
  before_save :handle_subjects_and_user_titles

  has_many :custom_field_options
  accepts_nested_attributes_for :custom_field_options, allow_destroy: true, reject_if: proc { |attributes| attributes['label'].blank? }

  has_many :custom_field_values

  scope :effective, -> { where('effect_at < :now and :now < expire_at', now: Time.now) }

  def set_subjects_and_user_titles
    self.subjects ||= (self.subject || '').split(',')
    self.user_titles ||= (self.user_title || '').split(',')
  end

  def handle_subjects_and_user_titles
    self.subject = self.subjects.reject(&:blank?).join(',')
    self.user_title = self.user_titles.reject(&:blank?).join(',')
  end

  def self.for_user(user)
    CustomField.displayable.effective.to_a.select do |custom_field|
      (custom_field.subjects.blank? || (custom_field.subjects & user.interested_curriculums).present?) &&
        (custom_field.user_titles.blank? || custom_field.user_titles.include?(user.title))
    end
  end
end
