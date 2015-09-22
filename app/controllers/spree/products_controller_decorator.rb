Spree::ProductsController.class_eval do
  include TaxonsFilter

  def index
    products_list_with_taxons_filter
  end
end
