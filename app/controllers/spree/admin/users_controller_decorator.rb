Spree::Admin::UsersController.class_eval do
  def licenses
    @user = Spree::User.find(params[:id])
    @licensed_products = Spree::LicensedProduct.where(user_id: @user.id).includes(:product).page(params[:page])
  end
end
