Spree::Product.class_eval do
  validates :license_length, numericality: { only_integer: true }
end
