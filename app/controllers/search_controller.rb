class SearchController < ApplicationController
  def index
    @result = Page.search(params[:query], index_name: [Spree::Product.searchkick_index.name, Page.searchkick_index.name, Spree::Video.searchkick_index.name])
  end
end
