class Recommendation < ActiveRecord::Base

  include Viewable, Clickable, Displayable, DashboardFilterable
  validates_presence_of :title, :sub_header, :call_to_action_button_text, :call_to_action_button_link
  validates_length_of :sub_header, :maximum => 85
  has_and_belongs_to_many :products, class_name: 'Spree::Product', join_table: 'products_recommendations'
  scope :with_subject, ->(subject){ where(subject: subject) if subject.present? }
  scope :unexpired, -> { where('expire_at is null or expire_at > ?', Time.now) }
  scope :search_by_title, ->(q) { where("title ilike ?", "%#{q}%") if q.present? }
  scope :search_by_user_title, ->(q) { where("user_title ilike ?", "%#{q}%") if q.present? }

  ICONS = ['BLOG', 'DIGITAL_SUITE', 'PDF', 'PRINT', 'PROFESSIONAL', 'VIDEO']

  def icon_image
    "recommendations/#{self.icon}.png"
  end

end
