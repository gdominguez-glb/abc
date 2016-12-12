class Recommendation < ActiveRecord::Base
  validates_presence_of :title, :sub_header, :call_to_action_button_text, :call_to_action_button_link

  has_and_belongs_to_many :products, class_name: 'Spree::Product', join_table: 'products_recommendations'

  scope :with_subject, ->(subject){ where(subject: subject) }
  scope :filter_by_subject_or_user_title_or_zip_code, -> (subjects, user_title, zip_code) {
    filter_conds = []
    filter_conds << "(subject in (:subject))" if subjects.present?
    filter_conds << "(user_title = :user_title)" if user_title.present?
    filter_conds << "(zip_codes like :zip_code)" if zip_code.present?

    if filter_conds.present?
      where(filter_conds.join(" or "), subject: subjects, user_title: user_title, zip_code: "%#{zip_code}%")
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
