Spree::HomeController.class_eval do
  include ProductTaxonsFilter
  include ProductsSearchHelper
  include PreferenceFilterable

  def index
    if params[:remove_all].present?
      clear_preference_filters
      redirect_to spree.root_path and return
    end

    filter_by_preferences

    @products = products_list_with_taxons_filter

    if params[:taxon_ids].present? && grade_taxon_selected?
      @products = @products.sort_group_first
    else
      @products = @products.show_in_storefront
    end
    @products = @products.unexpire.unarchive.search_by_text(params[:q]).page(params[:page]).per(10)
  end

  def grade_taxon_selected?
    Spree::Taxonomy.show_in_store.find_by(name: 'Grade').taxons.where(id: params[:taxon_ids]).exists?
  rescue
    nil
  end
end
