class Account::ProductsController < Account::BaseController
  def index
    @nav_name = 'My Products'

    @my_products       = current_spree_user.products.distinct
    @recent_activities = current_spree_user.activities.recent
    @recommendations   = Recommendation.limit(2)
  end
end
