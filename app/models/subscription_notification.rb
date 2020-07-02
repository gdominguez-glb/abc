class SubscriptionNotification < ApplicationRecord
  belongs_to :subscription
  belongs_to :article

  after_create :send_notification_email

  def send_notification_email
    SubscriptionNotifier.notify(self.subscription.id, self.article.id).deliver_now
  end
end
