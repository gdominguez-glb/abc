Spree::Product.class_eval do
  validates :license_length, numericality: { only_integer: true }
  validates :redirect_url, format: { with: URI.regexp },
    if: Proc.new { |a| a.redirect_url.present? }
end
