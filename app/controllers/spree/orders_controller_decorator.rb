Spree::OrdersController.class_eval do

  def update
    unless validate_line_item_quantity!
      redirect_to :back and return
    end
    if @order.contents.update_cart(order_params)
      respond_with(@order) do |format|
        format.html do
          if params.has_key?(:checkout)
            @order.next if @order.cart?
            redirect_to checkout_state_path(@order.checkout_steps.first)
          else
            redirect_to cart_path
          end
        end
      end
    else
      respond_with(@order)
    end
  end

  def validate_line_item_quantity!
    if params[:order] && params[:order][:line_items_attributes]
      params[:order][:line_items_attributes].each do |key, line_item_params|
        product = Spree::LineItem.find(line_item_params[:id]).product
        if line_item_params[:quantity].to_i > product.max_quantity_to_purchase
          flash[:error] = "To place an order for more than #{product.max_quantity_to_purchase} licenses of this #{product.free? ? 'free' : 'paid' } product you must <a href='/contact'>contact us</a>.".html_safe
          return false
        end
      end
    end
    true
  end

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

  def completed
    @order = current_spree_user.orders.find_by(number: params[:id])
  end

  def free_product
    if !try_spree_current_user
      session['spree_user_return_to'] = request.referrer
      redirect_to spree.login_path and return
    end

    product = Spree::Product.find(params[:product_id])
    if !product.free?
      flash[:error] = 'Only work for free product'
      redirect_to :back and return
    end

    if current_spree_user.accessible_products.include?(product)
      flash[:error] = "Already have #{product.name} in your dashboard."
      redirect_to :back and return
    end

    FreeProductOrder.new(try_spree_current_user, [product]).save
    redirect_to main_app.account_products_path, notice: "Successfully added #{product.name} to dashboard."
  end
end

