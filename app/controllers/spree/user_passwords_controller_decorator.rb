Spree::UserPasswordsController.class_eval do
  def after_resetting_password_path_for(resource_or_scope)
    '/account'
  end
end
