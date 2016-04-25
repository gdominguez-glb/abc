class AdminNewLicensesForm
  include ActiveModel::Model

  attr_accessor :user_id, :email, :product_ids, :fulfillment_at,
                :payment_method_id, :payment_source_params, :admin_user, :sf_contact_id,
                :salesforce_order_id, :salesforce_account_id, :amount, :products_quantity

  validates_presence_of :salesforce_order_id, :salesforce_account_id
  validates_presence_of :user_id, if: -> { email.blank? }
  validates :email,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
            presence: true, if: -> { user_id.blank? }
  validates_presence_of :products_quantity

  def products
    @products ||= Spree::Product.where(id: product_ids.split(','))
  end

  def safe_date_parse(date)
    Date.parse(date) rescue nil
  end

  def perform
    create_order
  end

  def create_order
    order = Spree::Order.new(
      email: email,
      user_id: (user_id.present? ? user_id : Spree::User.find_by(email: email).try(:id)),
      source: 'fulfillment',
      total: self.amount,
      item_total: self.amount,
      skip_salesforce_create: true,
      sf_contact_id: (sf_contact_id.present? ? sf_contact_id : nil),
      admin_user: admin_user,
      fulfillment_at: fulfillment_at
    )
    add_line_items(order)

    order.save

    create_order_salesforce_reference(order)

    process_order(order)
    order.tap { associate_school_district(order) }
  end

  def add_line_items(order)
    products_quantity.each do |product_id, quantity|
      product = Spree::Product.find(product_id)
      order.line_items << Spree::LineItem.new(variant: product.master,
                                              quantity: quantity)
    end
  end

  def add_payments(order)
    order.payments << build_payment if payment_method_id.present?
    order.save
  end

  def process_order(order)
    count = 0
    while count < 6
      add_payments(order) if order.state == 'payment'
      order.next if order.state != 'complete'
      count += 1
    end
  end

  def create_order_salesforce_reference(order)
    SalesforceReference.create(id_in_salesforce: salesforce_order_id,
                               local_object: order,
                               object_properties: { 'Id' => salesforce_order_id })
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
