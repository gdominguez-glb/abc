Spree::HomeController.class_eval do
  include ProductTaxonsFilter

  def index
    @products = products_list_with_taxons_filter

    if params[:taxon_ids].blank?
      @products = @products.show_in_storefront
    else
      @products = @products.sort_group_first
    end
    @products = @products.unarchive.page(params[:page]).per(10)
  end
end
