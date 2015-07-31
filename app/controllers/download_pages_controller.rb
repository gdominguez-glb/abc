class DownloadPagesController < ApplicationController
  before_action :find_download_page

  helper_method :locked_product?

  def show
    redirect_to root_path if @download_page.blank?

    @products = @download_page.products
    @boughted_products = current_spree_user.products.where(id: @products.map(&:id))
  end

  def download
    material = Spree::Material.find(params[:material_id])
    redirect_to material.material_files.first.file.url
  end

  def materials
    @product = @download_page.products.find(params[:product_id])
    render layout: false
  end

  private

  def find_download_page
    @download_page = DownloadPage.find_by(slug: params[:slug])
  end

  def locked_product?(product)
    !product.free? && !@boughted_products.include?(product)
  end
end
