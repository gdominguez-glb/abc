class FreeProductOrder
  include ManualOrderable

  attr_accessor :order

  def initialize(user, product)
    @user = user
    @product = product
  end

  def save
    @order = @user.orders.build(
      email: @user.email,
      total: 0,
      item_total: 0,
      fulfillment_at: Time.now,
      school_district: @user.school_district
    )
    @order.line_items << Spree::LineItem.new(variant: @product.master, quantity: 1)

    @order.save

    process_order(@order)
  end
end
