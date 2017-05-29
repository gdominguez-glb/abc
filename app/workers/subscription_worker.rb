class SubscriptionWorker
  include Sidekiq::Worker

  def perform(article_id)
    article = Article.find(article_id)
    article.blog.subscriptions.each do |subscription|
      SubscriptionNotification.find_or_create_by(subscription_id: subscription.id, article_id: article.id)
    end
  end
end
