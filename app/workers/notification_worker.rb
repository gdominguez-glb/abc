class NotificationWorker
  include Sidekiq::Worker

  def perform(notification_trigger_id)
    nt = NotificationTrigger.find(notification_trigger_id)
    users = if nt.single_user_target?
              [nt.single_user]
            elsif nt.school_district_target?
              [nt.school_district_admin_user.to_users]
            elsif nt.group_users_target?
              nt.group_users
            elsif nt.user_type_target?
              Spree::User.send("with_#{nt.user_type.downcase}_title")
            elsif nt.every_target?
              Spree::User.where("1 = 1")
            elsif nt.curriculum_users_target?
              Spree::User.with_curriculum(nt.curriculum)
            elsif nt.product_target?
              find_product_target_users(nt.product_id)
            elsif nt.zip_codes_target?
              find_zip_codes_target_users(nt.zip_codes)
            end
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

  def find_product_target_users(product_id)
    user_ids = []
    Spree::User.find_each do |user|
      user_ids << user.id if user.accessible_products.where(id: product_id).exists?
    end
    Spree::User.where(id: user_ids)
  end

  def find_zip_codes_target_users(zip_codes)
    Spree::User.where(zip_code: zip_codes.split(',').map(&:strip))
  end
end
