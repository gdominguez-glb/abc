class Account::FavoritesController < Account::BaseController
  def index
    @favorite_products = current_spree_user.favorite_products.includes(:product)
  end

  def destroy
    favorite_product = current_spree_user.favorite_products.find(params[:id])
    favorite_product.destroy
    redirect_to account_favorites_path
  end
end
