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
    @my_products = spree_current_user.accessible_products.select('spree_products.*, COALESCE(activities.updated_at, null) AS activities_update_at')
                       .joins("LEFT JOIN activities ON (activities.item_id = spree_products.id AND action = 'launch_resource' AND item_type = 'Spree::Product' AND user_id = #{spree_current_user.id})")
                       .where('spree_products.product_type != ?', 'bundle').order('activities_update_at DESC NULLS LAST')

    filter_by_preferences

    @my_products = filter_by_taxons(Spree::Product, @my_products, params[:taxon_ids])
    @my_products = @my_products.search_by_text(params[:q]).distinct.page(params[:page]).per(10)
    @taxonomies = Spree::Taxonomy.show_in_store.includes(root: :children)
  end

end
