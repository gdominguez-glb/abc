Spree::UserRegistrationsController.class_eval do
  private
    def spree_user_params
      params.require(:spree_user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
end
