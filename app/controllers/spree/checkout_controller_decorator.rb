Spree::CheckoutController.class_eval do

  # override to custom page after complete order
  def completion_route(custom_params = nil)
    if @order.all_digitals?
      flash.notice = "You now have access to these products!"
      '/account'
    else
      spree.order_path(@order, custom_params)
    end
  end

end