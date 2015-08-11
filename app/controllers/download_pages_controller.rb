class DownloadPagesController < ApplicationController
  before_action :find_download_page

  helper_method :locked_product?

  def show
    redirect_to root_path if @download_page.blank?

    @products            = @download_page.products
    @boughted_products   = current_spree_user.products.where(id: @products.map(&:id))

    product_tracks       = current_spree_user.product_tracks.where(product_id: @products.map(&:id))

    @opened_product_ids  = product_tracks.map(&:product_id)
    @opened_material_ids = product_tracks.map(&:material).compact.map(&:self_and_ancestors).flatten.map(&:id).uniq
  end

  private

  def find_download_page
    @download_page = DownloadPage.find_by(slug: params[:slug])
  end

  def locked_product?(product)
    !product.free? && !@boughted_products.include?(product)
  end
end
