Spree::ProductsController.class_eval do
  include TaxonsFilter

  before_action :find_launch_product, only: [:launch, :terms, :agree_terms]

  def index
    products_list_with_taxons_filter
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
      "#{product.access_url}?#{{opened_product_id: product.id}.to_param}"
    end
  end

  def find_launch_product
    @product = current_spree_user.products.find_by(slug: params[:id])
    redirect_to main_app.root_path and return if @product.blank?
  end
end
