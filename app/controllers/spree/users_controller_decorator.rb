Spree::UsersController.class_eval do
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
