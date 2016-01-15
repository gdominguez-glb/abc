Spree::HomeController.class_eval do
  include TaxonsFilter

  def index
    products_list_with_taxons_filter
    @products = @products.show_in_storefront.page(params[:page]).per(10)
  end
end
