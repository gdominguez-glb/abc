class FreeProductOrder
  include ManualOrderable

  attr_accessor :order

  def initialize(user, products)
    @user = user
    @products = products
  end

  def save
    @order = @user.orders.build(
      email: @user.email,
      total: 0,
      item_total: 0,
      fulfillment_at: Time.now,
      school_district: @user.school_district
    )
    @products.each do |product|
      @order.line_items << Spree::LineItem.new(variant: product.master, quantity: 1)
    end
    @order.save

    process_order(@order)
  end
end
