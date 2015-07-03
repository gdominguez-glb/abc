class NotificationTrigger < ActiveRecord::Base
  serialize :user_ids, Array

  validates_presence_of :content, :notify_at

  has_many :notifications

  belongs_to :single_user, class_name: 'Spree::User'
  belongs_to :school_district_admin_user, class_name: 'Spree::User'

  after_create :send_notifications

  TARGET_TYPES = [
    :single_user,
    :group_users,
    :school_district,
    :user_type,
    :every
  ]

  TARGET_TYPES.each do |target_type|
    define_method("#{target_type}_target?") do
      self.target_type == target_type.to_s
    end
  end

  def group_users
    User.where(id: self.user_ids)
  end

  def deliver!
    update(status: 'delivered')
  end

  private

  def send_notifications
    NotificationWorker.perform_at(self.notify_at, self.id) if self.notify_at.present?
  end
end
