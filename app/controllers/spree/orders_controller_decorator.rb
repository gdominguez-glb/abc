Spree::OrdersController.class_eval do

  # Adds a new item to the order (creating a new order if none already exists)
  def populate
    order    = current_order(create_order_if_necessary: true)
    variant  = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    options  = params[:options] || {}

    if quantity.between?(1, 2_147_483_647)
      begin
        if variant.free? || quantity.between?(1, 15)
          order.contents.add(variant, quantity, options)
        else
          error = "To place an order for more than 15 licenses of this product you must <a href='/contact'>contact us</a>.".html_safe
        end
      rescue ActiveRecord::RecordInvalid => e
        error = e.record.errors.full_messages.join(", ")
      end
    else
      error = Spree.t(:please_enter_reasonable_quantity)
    end

    if error
      flash[:error] = error
      redirect_to spree.product_path(variant.product)
    else
      respond_with(order) do |format|
        format.html { redirect_to cart_path }
      end
    end
  end

  def update_simple_cart
    @order = current_order || Spree::Order.incomplete.find_or_initialize_by(guest_token: cookies.signed[:guest_token])
    @order.contents.update_cart(order_params)

    respond_to do |format|
      format.html {
        redirect_to spree.checkout_state_path(@order.checkout_steps.first)
      }
      format.js {}
    end
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
