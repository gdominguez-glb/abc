class Notification < ActiveRecord::Base
  belongs_to :notification_trigger
  belongs_to :user, class_name: 'Spree::User'

  scope :unread, -> { where(read: false).order('notifications.created_at desc') }
  scope :unexpire, -> { where('expire_at is null or expire_at > ?', Time.now) }
  scope :viewed, -> { where(viewed: true) }

  def mark_as_read!
    update(read: true)
    log_activity(:read)
  end


  def mark_as_viewed!
    update(viewed: true)
    log_activity(:viewed)
  end

  def log_activity(action)
    if self.user
      self.user.log_activity(
        title: self.content,
        item: self,
        action: action
      )
    end
  end
end
