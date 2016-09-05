class SearchController < ApplicationController
  def index
    @result = Page.search(params[:query], generate_search_options)
  end

  def generate_search_options
    options = { index_name: [
      Spree::Product.searchkick_index.name,
      Page.searchkick_index.name,
      Post.searchkick_index.name,
      EventPage.searchkick_index.name,
      EventTraining.searchkick_index.name,
      Job.searchkick_index.name,
      Question.searchkick_index.name,
      MediumPublication.searchkick_index.name,
      CustomIndexPage.searchkick_index.name
    ] }
    if current_spree_user
      options[:index_name].concat([Spree::Material.searchkick_index.name, Spree::Video.searchkick_index.name])
      options[:where] = { user_ids: [current_spree_user.id, -1] }
    end
    options
  end

  def product
    product = Spree::Product.find(params[:id])
    if product.access_url && current_spree_user && current_spree_user.has_active_license_on?(product)
      redirect_to product.access_url || product.group_parent_access_url || spree.product_path(product)
    else
      redirect_to spree.product_path(product)
    end
  end
end
