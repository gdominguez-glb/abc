class Recommendation < ActiveRecord::Base
  validates_presence_of :title, :sub_header, :call_to_action_button_text, :call_to_action_button_link

  has_and_belongs_to_many :products, class_name: 'Spree::Product', join_table: 'products_recommendations'

  scope :with_subject, ->(subject){ where(subject: subject) }
  scope :filter_by_subject_or_user_title, -> (subjects, user_title) {
    if subjects.present? && user_title.present?
      where("subject in (?) or user_title = ?", subjects, user_title)
    elsif subjects.present?
      where(subject: subjects)
    elsif user_title.present?
      where(user_title: user_title)
    else
      where('1=1')
    end
  }
  scope :displayable, ->{ where(display:true).order('position ASC') }

  scope :displayable_random, ->{ where(display:true).order("RANDOM()") }

  ICONS = ['BLOG', 'DIGITAL_SUITE', 'PDF', 'PRINT', 'PROFESSIONAL', 'VIDEO']

  def icon_image
    "recommendations/#{self.icon}.png"
  end

  def increase_clicks!
    update(clicks: self.clicks + 1)
  end

  def increase_views!
    update(views: self.views + 1)
  end
end
