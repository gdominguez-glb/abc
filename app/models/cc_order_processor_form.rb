class CcOrderProcessorForm
  include ActiveModel::Model

  attr_accessor :salesforce_order_id, :amount, :admin_user, :email, :payment_source_params

  validates_presence_of :salesforce_order_id, :amount
  validates_numericality_of :amount, greater_than: 0

  def perform
    order = create_order
    create_order_salesforce_reference(order)
    order.manual_process_order!(build_payment)
  end

  def create_order
    Spree::Order.create(
      email: email,
      source: 'cc_process',
      total: self.amount,
      item_total: self.amount,
      skip_salesforce_create: true,
      admin_user: admin_user
    )
  end

  def create_order_salesforce_reference(order)
    SalesforceReference.create(id_in_salesforce: salesforce_order_id,
                               local_object: order,
                               object_properties: { 'Id' => salesforce_order_id })
  end

  def build_payment
    payment_method_id = Spree::PaymentMethod.find_by(name: 'Credit Card').try(:id).to_s
    payment_attributes = {
      amount: (amount || 0),
      payment_method_id: payment_method_id,
      source_attributes: payment_source_params[payment_method_id].permit!
    }
    Spree::Payment.new(payment_attributes)
  end
end
