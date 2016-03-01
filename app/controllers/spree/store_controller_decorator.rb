Spree::StoreController.class_eval do
  skip_before_action :accepted_terms, only: [:cart_link]

  def render_404(exception = nil)
    redirect_to not_found_path and return
  end
end
