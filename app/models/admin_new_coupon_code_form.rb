class AdminNewCouponCodeForm
  include ActiveModel::Model
  include ManualOrderable

  attr_accessor :code, :admin_email, :school_district_id, :schools_xls, :school_lists, :product_ids, :total_quantity, :sync_specified_order, :sf_order_id, :amount, :payment_method_id, :products_quantity, :payment_source_params, :coupon_code, :school_lists

  validates_presence_of :admin_email, :school_district_id, :products_quantity

  def perform
    build_coupon_code
    build_order
    success = @coupon_code.save
    complete_order if success
    success
  end

  def build_coupon_code
    @coupon_code = Spree::CouponCode.new(
      code: self.code,
      school_lists: self.school_lists,
      total_quantity: self.total_quantity,
      school_district_id: self.school_district_id,
      sync_specified_order: self.sync_specified_order,
      sf_order_id: self.sf_order_id,
      product_ids: (self.product_ids.split(','))
    )
  end

  def build_order
    admin_user = Spree::User.find_by(email: self.admin_email)
    order = @coupon_code.build_order(
      email: self.admin_email,
      user: admin_user,
      source: :coupon_code_order,
      total: self.amount,
      item_total: self.amount,
      admin_user: admin_user,
      school_district_id: self.school_district_id
    )
    add_line_items(order)
    if self.sync_specified_order == '1' && self.sf_order_id.present?
      order.build_salesforce_reference(id_in_salesforce: self.sf_order_id)
    end
  end

  def add_line_items(order)
    @coupon_code.products.each do |product|
      order.line_items.build(quantity: 1, variant: product.master)
    end
  end

  def complete_order
    if payment_method_id.present?
      process_order(@coupon_code.order)
    else
      @coupon_code.order.update(state: 'complete')
    end
  end
end
