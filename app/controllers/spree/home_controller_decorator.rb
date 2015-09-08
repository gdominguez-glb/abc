Spree::HomeController.class_eval do
  def index
    @searcher   = build_searcher(params.merge(include_images: true))
    @products   = @searcher.retrieve_products
    @taxonomies = Spree::Taxonomy.includes(root: :children)

    @products   = @products.where(individual_sale: true).saleable
  end
end
