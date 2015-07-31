class DownloadPagesController < ApplicationController
  before_action :find_download_page

  def show
    redirect_to root_path if @download_page.blank?

    @products = @download_page.products
  end

  def download
    material = Spree::Material.find(params[:material_id])
    redirect_to material.material_files.first.file.url
  end

  private

  def find_download_page
    @download_page = DownloadPage.find_by(slug: params[:slug])
  end
end
