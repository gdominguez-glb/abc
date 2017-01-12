class Account::ResourcesController < Account::BaseController

  include TaxonFilterable
  include ProductsSearchHelper
  include PreferenceFilterable

  include Spree::Core::ControllerHelpers::Store

  def index
    params[:taxon_ids] ||= []

    if params[:remove_all].present?
      clear_preference_filters
      redirect_to account_resources_path and return
    end

    @nav_name = 'My Resources'
    @my_products = spree_current_user.my_resources

    filter_by_preferences

    @my_products = filter_by_taxons(Spree::Product, @my_products, params[:taxon_ids])
    @my_products = @my_products.search_by_text(params[:q]).distinct.page(params[:page]).per(10)
    @taxonomies = Spree::Taxonomy.show_in_store.includes(root: :children)
  end

end
