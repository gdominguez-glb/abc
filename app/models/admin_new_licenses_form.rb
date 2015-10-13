class AdminNewLicensesForm
  include ActiveModel::Model

  attr_accessor :user_id, :email, :product_ids, :quantity, :fulfillment_at, :payment_method_id, :payment_source_params

  # validates_presence_of :product_ids
  validates_numericality_of :quantity, greater_than_or_equal_to: 0, only_integer: true, allow_blank: true
  validates_presence_of :user_id, if: -> { self.email.blank? }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, presence: true, if: -> { self.user_id.blank? }
  
  def products
    @products ||= Spree::Product.where(id: self.product_ids.split(','))
  end

  def perform
    rows = products.map {|product|
      { product: product, email: self.email, user_id: self.user_id, quantity: self.quantity, fulfillment_at: (Date.parse(self.fulfillment_at) rescue nil) }
    }
    Spree::LicensesManager::LicensesCreator.new(rows).execute
    create_order
  end

  def create_order
    order = Spree::Order.new(email: self.email, user_id: self.user_id)
    products.each do |product|
      order.line_items << Spree::LineItem.new(variant: product.master, quantity: self.quantity)
    end
    order.payments << build_payment
    order.save
  end

  def build_payment
    payment_attributes = {
      amount: 0,
      payment_method_id: self.payment_method_id,
      source_attributes: payment_source_params[self.payment_method_id].permit!
    }
    Spree::Payment.new(payment_attributes)
  end
end
