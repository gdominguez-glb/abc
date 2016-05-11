Spree::ProductsController.class_eval do
  include ProductTaxonsFilter

  before_action :find_launch_product, only: [:launch, :terms, :agree_terms]

  def index
    @products = products_list_with_taxons_filter
  end

  def launch
    path = path_to_redirect_for_product(@product)
    (redirect_to terms_product_path and return) if @product.license_text.present? && !current_spree_user.agree_term_of_product?(@product)
    redirect_to (path ? path : main_app.root_path)
  end

  def terms
  end

  def agree_terms
    current_spree_user.product_agreements.find_or_create_by(product: @product)
    redirect_to launch_product_path(@product)
  end

  def path_to_redirect_for_product(product)
    if product.product_type == 'inkling'
      main_app.inkling_code_path(product)
    elsif product.access_url.present?
      product.parsed_access_url
    end
  end

  def find_launch_product
    @product = current_spree_user.products.find_by(slug: params[:id]) || current_spree_user.part_products.find_by(slug: params[:id])
    if @product.blank?
      flash[:error] = "This product is currently inactive. You will have access on your fulfillment date. If you have any questions, please contact us."
      redirect_to main_app.account_products_path
      return
    end
  end

  def group
    @product_group = Spree::Product.find_by(slug: params[:id])
    if @product_group.blank?
      redirect_to not_found_path and return
    end
    @products = @product_group.group_items.order('spree_group_items.created_at asc')
  end

  def show
    redirect_to @product.get_in_touch_url if @product.get_in_touch_product?
    @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
    @product_properties = @product.product_properties.includes(:property)
    @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
  end
end
