class Subscription < ApplicationRecord
  belongs_to :blog
  belongs_to :user, class_name: 'Spree::User'

  after_create :send_subscription_email

  after_destroy :remove_from_mailchimp_list

  def send_subscription_email
    SubscriptionWorker.delay.perform(self.blog_id, self.user_id)
  end

  def remove_from_mailchimp_list
    SubscriptionWorker.delay.unsubscribe(self.blog_id, self.user_id)
  end
end
