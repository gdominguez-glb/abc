class SubscriptionNotifier < ApplicationMailer

  def notify(subscription_id, article_id)
    @subscription = Subscription.find(subscription_id)
    @article = Article.find(article_id)
    mail to: @subscription.user.email, subject: "#{@article.blog.title} - #{@article.title}"
  end
end
