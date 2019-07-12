class Api::OrderController < Api::BaseController
  def create
    @new_licenses_form = AdminNewLicensesForm.new(new_licenses_form_params.merge(
      payment_source_params: params[:payment_source],
      products_quantity: products_quantity,
      admin_user: current_spree_user
    ))
    @order = Spree::Order.new

    if @new_licenses_form.valid?
      @new_licenses_form.perform

      render json: { success: true }
    else
      render json: @new_licenses_form.errors.messages
    end
  end

  def new_licenses_form_params
    params.require(:admin_new_licenses_form).permit(
      :user_id,
      :email,
      :product_ids,
      :quantity,
      :payment_method_id,
      :fulfillment_at,
      :salesforce_order_id,
      :salesforce_account_id,
      :sf_contact_id,
      :enable_single_distribution,
      :allow_fulfill_without_salesforce,
      :amount
    )
  end

  def products_quantity
    params[:products].map do |key, value|
      product = Spree::Product.find_by(sf_id_product: key)

      { product.id.to_s => value }
    end.reduce Hash.new, :merge
  end
end
