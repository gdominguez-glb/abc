class NotificationWorker
  include Sidekiq::Worker

  def perform(notification_trigger_id)
    nt = NotificationTrigger.find(notification_trigger_id)
    users = if nt.single_user_target?
              [nt.single_user]
            elsif nt.school_district_target?
              [nt.school_district_admin_user.to_users]
            elsif nt.group_user_target?
              nt.group_users
            elsif nt.user_type_target?
              User.send("with_#{nt.user_type.downcase}_title")
            elsif nt.every_target?
              User.where("1 = 1")
            end
    delivery_notifications(nt, users) if users.present?
    nt.deliver!
  end

  def delivery_notifications(notification_trigger, users)
    notify_proc = Proc.new do |user|
      Notification.create(
        user: user,
        notification_trigger: notification_trigger,
        content: notification_trigger.content
      )
    end
    if users.respond_to?(:find_each)
      users.find_each(&notify_proc)
    else
      users.each(&notify_proc)
    end
  end
end
