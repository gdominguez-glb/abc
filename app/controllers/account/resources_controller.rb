class Account::ResourcesController < Account::BaseController

  include TaxonFilterable
  include ProductsSearchHelper
  include Spree::Core::ControllerHelpers::Store
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth

  def index
    if params[:remove_all].present?
      clear_preference_filters
      redirect_to account_resources_path and return
    end

    @nav_name = 'My Resources'
    @my_products = spree_current_user.products_in_dashboard

    apply_preference_filters if params[:taxon_ids].blank?

    if params[:taxon_ids].nil?
      params[:taxon_ids] = []
    else
      @my_products = filter_by_taxons(Spree::Product, @my_products, params[:taxon_ids])
    end

    @my_products = @my_products.search_by_text(params[:q]).page(params[:page])
    @total = @my_products.length
    @my_products = @my_products.per(10)
    @taxonomies = Spree::Taxonomy.show_in_store.includes(root: :children)
  end

  def apply_preference_filters
    if session[:filter_role].present? && session[:filter_curriculum].present?
      subject_id = find_taxon_by_taxonomy_and_name('Subject', session[:filter_curriculum])
      role_id    = find_taxon_by_taxonomy_and_name('I am a...', session[:filter_role])
      if subject_id && role_id
        params[:taxon_ids] = [subject_id, role_id]
      end
    end
  end

  def find_taxon_by_taxonomy_and_name(taxonomy_name, taxon_name)
    Spree::Taxonomy.show_in_store.find_by(name: taxonomy_name).taxons.find_by(name: taxon_name).id
  rescue
    nil
  end

end