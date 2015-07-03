class NotificationWorker
  include Sidekiq::Worker

  def perform(notification_trigger_id)
    notification_trigger = NotificationTrigger.find(notification_trigger_id)
    if notification_trigger.single_user_target? || notification_trigger.group_user_target?
      Spree::User.where(id: notification_trigger.user_ids).find_each do |user|
        Notification.create(
          user: user,
          notification_trigger: notification_trigger,
          content: notification_trigger.content
        )
      end
    end
  end
end
