class AdminNewLicensesForm
  include ActiveModel::Model

  attr_accessor :user_id, :email, :product_ids, :quantity, :fulfillment_at, :payment_method_id, :payment_source_params, :salesforce_order_id, :salesforce_account_id, :amount

  validates_presence_of :salesforce_order_id, :salesforce_account_id
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
    order.payments << build_payment if self.payment_method_id.present?
    order.save

    process_order(order)
    create_order_salesforce_reference(order)
    associate_school_district(order)
  end

  def process_order(order)
    while order.state != 'complete'
      order.next
    end
    process_payment(order)
  end

  def process_payment(order)
    payment = order.payments.last
    payment.process! if payment
  end

  def create_order_salesforce_reference(order)
    SalesforceReference.create(id_in_salesforce: self.salesforce_order_id, local_object: order)
  end

  def associate_school_district(order)
    school_district = SalesforceReference.find_by(id_in_salesforce: salesforce_account_id, local_object_type: 'SchoolDistrict').try(:local_object)
    order.update(school_district: school_district)
  end

  def build_payment
    payment_attributes = {
      amount: (self.amount || 0),
      payment_method_id: self.payment_method_id,
      source_attributes: payment_source_params[self.payment_method_id].permit!
    }
    Spree::Payment.new(payment_attributes)
  end
end
