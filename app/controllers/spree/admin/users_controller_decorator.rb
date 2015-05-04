Spree::Admin::UsersController.class_eval do
  def products
    @user = Spree::User.find(params[:id])
    @products = @user.products.page(params[:page]).per(Spree::Config[:admin_products_per_page])
  end
end
