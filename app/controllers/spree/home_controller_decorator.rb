Spree::HomeController.class_eval do
  include ProductTaxonsFilter
  include ProductsSearchHelper

  def index
    if params[:remove_all].present?
      clear_preference_filters
      redirect_to spree.root_path and return
    end
    apply_preference_filters if params[:taxon_ids].blank?

    @products = products_list_with_taxons_filter

    if params[:taxon_ids].present? && grade_taxon_selected?
      @products = @products.sort_group_first
    else
      @products = @products.show_in_storefront
    end
    @products = @products.unexpire.unarchive.search_by_text(params[:q]).page(params[:page]).per(10)
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

  def grade_taxon_selected?
    Spree::Taxonomy.show_in_store.find_by(name: 'Grade').taxons.where(id: params[:taxon_ids]).exists?
  rescue
    nil
  end
end
