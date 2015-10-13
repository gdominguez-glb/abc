class AdminNewLicensesForm
  include ActiveModel::Model

  attr_accessor :user_id, :email, :product_ids, :quantity, :fulfillment_at, :payment_method_id

  validates_presence_of :product_ids
  validates_numericality_of :quantity, greater_than: 0, only_integer: true
  validates_presence_of :user_id, if: -> { self.email.blank? }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, presence: true, if: -> { self.user_id.blank? }
  
  def perform
    products = Spree::Product.where(id: self.product_ids.split(','))
    rows = products.map {|product|
      { product: product, email: self.email, user_id: self.user_id, quantity: self.quantity, fulfillment_at: (Date.parse(self.fulfillment_at) rescue nil) }
    }
    Spree::LicensesManager::LicensesCreator.new(rows).execute
  end
end
