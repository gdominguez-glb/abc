Spree::OrdersController.class_eval do
  def update_simple_cart
    @order = current_order || Order.incomplete.find_or_initialize_by(guest_token: cookies.signed[:guest_token])
    @order.contents.update_cart(order_params)
  end
end
