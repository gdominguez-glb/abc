Spree::Admin::UserSessionsController.class_eval do
  # override to remove flash message
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    yield if block_given?
    respond_to_on_destroy
  end
end
