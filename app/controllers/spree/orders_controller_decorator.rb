Spree::OrdersController.class_eval do
  def update_simple_cart
    @order = current_order || Spree::Order.incomplete.find_or_initialize_by(guest_token: cookies.signed[:guest_token])
    @order.contents.update_cart(order_params)
  end

  def add_products_to_cart
    order = current_order(create_order_if_necessary: true)
    variants = Spree::Product.where(id: params[:product_ids]).includes(:master).map(&:master)
    variants.each do |variant|
      order.contents.add(variant, 1, {})
    end
    redirect_to spree.cart_path
  end
end
