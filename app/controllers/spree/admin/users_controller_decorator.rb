Spree::Admin::UsersController.class_eval do
  def licenses
    @user = Spree::User.find(params[:id])
    @licensed_products = @user.licensed_products.includes(:product).page(params[:page])
  end
end
