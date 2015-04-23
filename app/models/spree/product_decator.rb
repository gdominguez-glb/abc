Spree::Product.class_eval do
  attr_accessible :license_text, :license_length

  validates :license_length, numericality: { only_integer: true }
end
