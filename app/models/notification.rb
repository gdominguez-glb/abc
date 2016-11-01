class Notification < ActiveRecord::Base
  belongs_to :notification_trigger
  belongs_to :user, class_name: 'Spree::User'

  scope :unread, -> { where(read: false).order('notifications.created_at desc') }
  scope :unexpire, -> { where('expire_at is null or expire_at > ?', Time.now) }
  scope :viewed, -> { where(viewed: true) }

  def mark_as_read!
    update(read: true)
  end

  after_create :log_activity

  def log_activity
    if self.user
      self.user.log_activity(
        title: self.content,
        item: self,
        action: :create
      )
    end
  end

  def mark_as_viewed!
    update(viewed: true)
  end
end
