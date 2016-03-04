Spree::Admin::ProductsController.class_eval do
  def index
    session[:return_to] = request.url
    @collection = @collection.where(archived: false)
    respond_with(@collection)
  end

  def archive
    @product = Spree::Product.find_by(slug: params[:id])
    @product.update_columns(archived: true, archived_at: Time.now)

    redirect_to admin_product_path(@product), notice: 'Successfully archive product'
  end

  def unarchive
    @product = Spree::Product.find_by(slug: params[:id])
    @product.update_columns(archived: false, archived_at: nil)

    redirect_to admin_product_path(@product), notice: 'Successfully un-archive product'
  end
end
