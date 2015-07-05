class Notification < ActiveRecord::Base
  belongs_to :notification_trigger
  belongs_to :user, class_name: 'Spree::User'

  scope :unread, -> { where(read: false).order('notifications.created_at desc') }

  def mark_as_read!
    update(read: true)
  end
end
