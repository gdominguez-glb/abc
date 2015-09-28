class SearchController < ApplicationController
  def index
    @result = Page.search(params[:query], generate_search_options)
  end

  def generate_search_options
    options = { index_name: [Spree::Product.searchkick_index.name, Page.searchkick_index.name, Spree::Video.searchkick_index.name] }
    if current_spree_user
      options[:index_name] << Spree::Material.searchkick_index.name
      options[:where] = { user_ids: [current_spree_user.id, -1] }
    end
    options
  end
end
