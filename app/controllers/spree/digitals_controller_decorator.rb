Spree::DigitalsController.class_eval do
  before_action :log_activity, only: [:show]

  def log_activity
    if attachment.present? && current_spree_user && product = digital_link.try(:digital).try(:variant).try(:product)
      current_spree_user.log_activity(
        item: product,
        title: product.name,
        action: 'download'
      )
    end
  end
end
