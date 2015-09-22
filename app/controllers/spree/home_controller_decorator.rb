Spree::HomeController.class_eval do
  def index
    params[:taxon_ids] ||= []
    params[:taxon_ids] = params[:taxon_ids].map(&:to_i)

    @searcher   = build_searcher(params.merge(include_images: true))
    @products   = @searcher.retrieve_products
    @taxonomies = Spree::Taxonomy.show_in_store.includes(root: :children)

    @products   = @products.where(individual_sale: true).saleable

    if params[:taxon_ids].present?
      @products = @products.in_taxons(Spree::Taxon.where(id: params[:taxon_ids]))
    end
  end
end
