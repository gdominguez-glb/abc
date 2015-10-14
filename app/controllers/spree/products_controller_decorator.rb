Spree::ProductsController.class_eval do
  include TaxonsFilter

  def index
    products_list_with_taxons_filter
  end

  def launch
    product = current_spree_user.products.find_by(slug: params[:id])
    if product && path = path_to_redirect_for_product(product)
      redirect_to path
    else
      redirect_to root_path
    end
  end

  def path_to_redirect_for_product(product)
    if product.product_type == 'inkling'
      inkling_code_path(product)
    elsif product.access_url.present?
      "#{product.access_url}?#{{opened_product_id: product.id}.to_param}"
    end
  end
end
