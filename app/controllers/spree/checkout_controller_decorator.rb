Spree::CheckoutController.class_eval do

  before_action :check_order_address, only: [:edit]
  before_action :check_user_state, only: [:edit]

  # override to custom page after complete order
  def completion_route(custom_params = nil)
    if @order.all_digitals? && @order.license_admin_email.blank?
      flash.notice = "You now have access to these products!"
    end
    if @order.free?
      @order.single_purchase? ? main_app.account_products_path : main_app.account_root_path
    else
      spree.completed_order_path(@order, custom_params)
    end
  end

  def check_order_address
    if params[:state] != 'address' && @order.checkout_steps.include?('address') && @order.bill_address.blank? && @order.ship_address.blank?
      redirect_to spree.checkout_state_path(state: 'address') and return
    end
  end

  def check_user_state
    if params[:state] == 'address' &&
      !current_order.free? &&
      require_adoption_pricing_state?(current_spree_user.state_name || current_user_state)
      flash[:warning] = "We're unable to accept online orders from schools or districts in Louisiana and Tennessee at this time. If you're a teacher or administrator in Louisiana or Tennessee, please <a href='#{main_app.contact_path}'>contact us</a> and we will be happy to assist you."
    end
  end

  def current_user_state
    results = Geocoder.search(request.ip)
    results.first.data['region_name']
  rescue
    nil
  end

  def require_adoption_pricing_state?(state_name)
    ['Louisiana', 'Tennessee'].include?(state_name)
  end
end
