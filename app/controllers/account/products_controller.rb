class Account::ProductsController < Account::BaseController
  def index
    @nav_name = 'My Products'

    @my_products       = current_spree_user.products.distinct
    @recent_activities = current_spree_user.activities.recent
    @recommendations   = Recommendation.where(subject: current_spree_user.interested_subject).limit(3)

    @notifications = current_spree_user.notifications.unread.limit(5)
  end
end
