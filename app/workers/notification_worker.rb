class NotificationWorker
  include Sidekiq::Worker

  def perform(notification_trigger_id)
    nt = NotificationTrigger.find(notification_trigger_id)
    users = nt.calculate_target_users
    delivery_notifications(nt, users) if users.present?
    nt.deliver!
  end

  def delivery_notifications(notification_trigger, users)
    notify_proc = Proc.new do |user|
      if notification_trigger.dashboard?
        Notification.create(
          user: user,
          notification_trigger: notification_trigger,
          content: notification_trigger.content,
          expire_at: notification_trigger.expire_at
        )
      end
      if notification_trigger.email? && user.allow_communication?
        NotificationMailer.notify(user, notification_trigger.content).deliver_later
      end
    end
    if users.respond_to?(:find_each)
      users.find_each(&notify_proc)
    else
      users.each(&notify_proc)
    end
  end
end
