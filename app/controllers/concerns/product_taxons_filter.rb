module ProductTaxonsFilter
  extend ActiveSupport::Concern
  
  include TaxonFilterable

  def products_list_with_taxons_filter
    @searcher   = build_searcher(params.merge(include_images: true))
    @products   = @searcher.retrieve_products
    @taxonomies = Spree::Taxonomy.show_in_store.includes(root: :children)
    @products   = @products.where(individual_sale: true).saleable

    params[:taxon_ids] ||= []

    @products = filter_by_taxons(Spree::Product, @products, params[:taxon_ids]) unless params[:taxon_ids].blank?
    @products
  end
end
