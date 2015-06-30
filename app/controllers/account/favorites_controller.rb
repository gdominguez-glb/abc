class Account::FavoritesController < Account::BaseController
  def index
    @favorite_products = current_spree_user.favorite_products.includes(:product)
  end
end
