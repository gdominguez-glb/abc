class NotificationTrigger < ActiveRecord::Base
  serialize :user_ids, Array

  validates_presence_of :target_type, :content, :notify_at

  has_many :notifications

  belongs_to :single_user, class_name: 'Spree::User'
  belongs_to :school_district_admin_user, class_name: 'Spree::User'
  belongs_to :curriculum
  belongs_to :product, class_name: 'Spree::Product'

  after_create :send_notifications

  TARGET_TYPES = [
    :single_user,
    :group_users,
    :school_district,
    :user_type,
    :every,
    :curriculum_users,
    :product,
    :zip_codes
  ]

  TARGET_TYPES.each do |target_type|
    define_method("#{target_type}_target?") do
      self.target_type == target_type.to_s
    end
  end

  def group_users
    Spree::User.where(id: self.user_ids)
  end

  def deliver!
    update(status: 'delivered')
  end

  private

  def send_notifications
    NotificationWorker.perform_at(self.notify_at, self.id)
  end
end
