class DownloadPagesController < ApplicationController
  def show
    @download_page = DownloadPage.find_by(slug: params[:slug])
    redirect_to root_path if @download_page.blank?

    @products = @download_page.products
  end
end
