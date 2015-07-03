class NotificationTrigger < ActiveRecord::Base
  serialize :user_ids, Array

  validates_presence_of :content, :notify_at
  has_many :notifications

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

  USER_TYPES = [
    :district_admin,
    :teacher,
    :parent
  ]

  private

  def send_notifications
    NotificationWorker.perform_async(self.id)
  end
end
