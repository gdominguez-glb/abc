class DownloadPagesController < ApplicationController
  before_action :find_download_page

  helper_method :locked_product?

  def show
    redirect_to root_path if @download_page.blank?

    @products            = @download_page.products
    @boughted_products   = current_spree_user.products.where(id: @products.map(&:id))

    set_product_tracks
  end

  private

  def find_download_page
    @download_page = DownloadPage.find_by(slug: params[:slug])
  end

  def locked_product?(product)
    !product.free? && !@boughted_products.include?(product)
  end

  def set_product_tracks
    current_spree_user.product_tracks.find_or_create_by(product_id: params[:opened_product_id], material: params[:opened_material_id]) if params[:opened_product_id].present?
    product_tracks = current_spree_user.product_tracks.where(product_id: @products.map(&:id))

    @opened_product_ids     = product_tracks.map(&:product_id)
    @opened_material_ids    = product_tracks.map(&:material).compact.map(&:self_and_ancestors).flatten.map(&:id).uniq
    @material_ids_to_scroll = product_tracks.map(&:material_id).compact
  end
end
