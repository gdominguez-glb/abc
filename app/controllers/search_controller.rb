class SearchController < ApplicationController
  before_action :set_session_material, only: [:index]

  def index
    @result = Searchkick.search(params[:query], generate_search_options)
  end

  def generate_search_options
    options = { models: [
      Spree::Product,
      Page,
      EventPage,
      Job,
      Question,
      MediumPublication
    ] }
    if current_spree_user
      options[:models].concat([Spree::Material, Spree::Video])
      options[:where] = { user_ids: [current_spree_user.id, -1] }
    end
    options
  end

  def product
    product = Spree::Product.find(params[:id])
    if product.access_url.present? && current_spree_user && current_spree_user.has_active_license_on?(product)
      redirect_to product.access_url || product.group_parent_access_url || spree.product_path(product)
    else
      redirect_to spree.product_path(product)
    end
  end

  private
  def set_session_material
    session[:material_products] = []
  end
end
