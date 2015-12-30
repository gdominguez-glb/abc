Spree::StoreController.class_eval do
  def render_404(exception = nil)
    redirect_to not_found_path and return
  end
end
