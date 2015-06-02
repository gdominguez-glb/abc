Spree::ProductsController.class_eval do
  def favorite
    if current_spree_user
      product = Spree::Product.find_by(slug: params[:id])
      @favorite_product = current_spree_user.favorite_products.create(product_id: product.id)
    end
  end
end
