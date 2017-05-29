# Preview all emails at http://localhost:3000/rails/mailers/subscription_notifier
class SubscriptionNotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/subscription_notifier/notify
  def notify
    SubscriptionNotifier.notify
  end

end
