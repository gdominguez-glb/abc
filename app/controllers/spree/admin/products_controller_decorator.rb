Spree::Admin::ProductsController.class_eval do
  def archive
    @product = Spree::Product.find_by(slug: params[:id])
    @product.update_columns(archived: true, archived_at: Time.now)

    redirect_to admin_product_path(@product), notice: 'Successfully archive product'
  end
end
