Spree::Admin::ProductsController.class_eval do
  layout :resolve_layout
  include Spree::Core::ControllerHelpers::Order

  def index
    session[:return_to] = request.url
    @collection = @collection.where(archived: false)
    respond_with(@collection)
  end

  def archive
    @product = Spree::Product.find_by(slug: params[:id])
    @product.update_columns(
      archived: true,
      archived_at: Time.now,
      for_sale: false,
      show_in_storefront: false,
      individual_sale: false,
      can_be_part: false,
      auto_add_on_sign_up: false
    )

    redirect_to admin_product_path(@product), notice: 'Successfully archive product'
  end

  def preview
    @product = Spree::Product.find_by(slug: params[:id])
    @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
    @product_properties = @product.product_properties.includes(:property)

    if @product.group_product?
      @product_group = @product
      @products = @product_group.group_items.unexpire.unarchive.order('spree_group_items.created_at asc')
      render 'spree/products/group' and return
    end

    render 'spree/products/show'
  end

  def unarchive
    @product = Spree::Product.find_by(slug: params[:id])
    @product.update_columns(archived: false, archived_at: nil)

    redirect_to admin_product_path(@product), notice: 'Successfully un-archive product'
  end

  # TODO: Unused method we need to remove it
  def location_after_save
    session[:return_to] || admin_products_path
  end

  def resolve_layout
    case action_name
      when "preview"
        "spree/layouts/spree_application"
      else
        "spree/layouts/admin"
    end
  end
end
