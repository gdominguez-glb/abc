# AdminNewLicensesForm
class AdminNewLicensesForm
  include ActiveModel::Model

  attr_accessor :user_id, :email, :product_ids, :quantity, :fulfillment_at,
                :payment_method_id, :payment_source_params,
                :salesforce_order_id, :salesforce_account_id, :amount

  validates_presence_of :salesforce_order_id, :salesforce_account_id
  validates_numericality_of :quantity, greater_than_or_equal_to: 0,
                                       only_integer: true, allow_blank: true
  validates_presence_of :user_id, if: -> { email.blank? }
  validates :email,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
            presence: true, if: -> { user_id.blank? }

  def products
    @products ||= Spree::Product.where(id: product_ids.split(','))
  end

  def safe_date_parse(date)
    Date.parse(date) rescue nil
  end

  def perform
    order = create_order
    rows = products.map do |product|
      { product: product, email: email, user_id: user_id, quantity: quantity,
        fulfillment_at: safe_date_parse(fulfillment_at), order: order }
    end
    Spree::LicensesManager::LicensesCreator.new(rows).execute
  end

  def create_order
    order = Spree::Order.new(email: email, user_id: user_id)
    products.each do |product|
      order.line_items << Spree::LineItem.new(variant: product.master,
                                              quantity: quantity)
    end
    order.payments << build_payment if payment_method_id.present?
    order.save

    process_order(order)
    create_order_salesforce_reference(order)
    order.tap { associate_school_district(order) }
  end

  def process_order(order)
    order.next while order.state != 'complete'
    process_payment(order)
  end

  def process_payment(order)
    payment = order.payments.last
    payment.process! if payment
  end

  def create_order_salesforce_reference(order)
    SalesforceReference.create(id_in_salesforce: salesforce_order_id,
                               local_object: order)
  end

  def associate_school_district(order)
    school_district = SalesforceReference.find_by(
      id_in_salesforce: salesforce_account_id,
      local_object_type: 'SchoolDistrict').try(:local_object)
    order.update(school_district: school_district)
  end

  def build_payment
    payment_attributes = {
      amount: (amount || 0),
      payment_method_id: payment_method_id,
      source_attributes: payment_source_params[payment_method_id].permit!
    }
    Spree::Payment.new(payment_attributes)
  end
end
