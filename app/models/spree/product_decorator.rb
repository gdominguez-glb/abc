Spree::Product.class_eval do
  validates :license_length, numericality: { only_integer: true }, allow_blank: true
  validates :redirect_url, format: { with: URI.regexp }, allow_blank: true

  belongs_to :curriculum, class_name: 'Spree::Curriculum'
end
