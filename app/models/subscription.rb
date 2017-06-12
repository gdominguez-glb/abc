class Subscription < ActiveRecord::Base
  belongs_to :blog
  belongs_to :user, class_name: 'Spree::User'

  after_create :send_subscription_email

  def send_subscription_email
    SubscriptionWorker.delay.perform(self.blog_id, self.user_id)
  end
end
