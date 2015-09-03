class Account::FavoritesController < Account::BaseController
  def index
    @favorite_products = current_spree_user.favorite_products.includes([product: [:taxons]])

    @taxonomies = Spree::Taxonomy.all

    if params[:taxonomy_id].present?
      @favorite_products = @favorite_products.sort_by_taxons(params[:taxonomy_id]).to_a.uniq(&:id)
    end
  end

  def destroy
    favorite_product = current_spree_user.favorite_products.find(params[:id])
    favorite_product.destroy
    redirect_to account_favorites_path
  end
end
