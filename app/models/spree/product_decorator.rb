Spree::Product.class_eval do
  validates :license_length, numericality: { only_integer: true }, allow_blank: true
  validates :redirect_url, format: { with: URI.regexp }, allow_blank: true

  belongs_to :curriculum, class_name: 'Spree::Curriculum'
  belongs_to :grade, class_name: 'Spree::Grade'
  belongs_to :grade_unit, class_name: 'Spree::GradeUnit'

  PRODUCT_TYPES = [
    'curriculum',
    'video',
    'pdf',
    'other'
  ]
end
