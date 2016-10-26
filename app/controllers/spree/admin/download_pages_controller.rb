class Spree::Admin::DownloadPagesController < Spree::Admin::BaseController
  before_action :set_download_page, only: [:show, :edit, :update, :destroy]

  def index
    @q = DownloadPage.ransack(params[:q])
    @download_pages = @q.result.page(params[:page])
  end

  def new
    @download_page = DownloadPage.new
  end

  def create
    @download_page = DownloadPage.new(download_page_params)
    if @download_page.save
      redirect_to admin_download_pages_path, notice: 'Download page created successfully'
    else
      render :new
    end
  end

  def update
    if @download_page.update(download_page_params)
      redirect_to admin_download_pages_path, notice: 'Update download page successfully'
    else
      render :edit
    end
  end

  def destroy
    @download_page.destroy
    redirect_to admin_download_pages_path, notice: 'Destroy download page successfully'
  end

  private

  def download_page_params
    params.require(:download_page).permit(:title, :slug, :description)
  end

  def set_download_page
    @download_page = DownloadPage.find(params[:id])
  end
end
