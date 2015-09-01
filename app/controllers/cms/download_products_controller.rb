class Cms::DownloadProductsController < Cms::BaseController
  before_action :set_download_page
  before_action :set_download_product, only: [:show, :destroy]

  def index
    @download_products = @download_page.download_products.joins(:product)
  end

  def new
    @download_product = @download_page.download_products.build
    @products = Spree::Product.pdfs
  end

  def create
    @download_product = @download_page.download_products.new(download_product_params)
    if @download_product.save
      redirect_to cms_download_page_download_products_path(@download_page), notice: 'Product added successfully'
    else
      render :new
    end
  end

  def destroy
    @download_product.destroy
    redirect_to cms_download_page_download_products_path(@download_page), notice: 'Destroy download page successfully'
  end

  private

  def download_product_params
    params.require(:download_product).permit(:product_id)
  end

  def set_download_product
    @download_product = DownloadProduct.find(params[:id])
  end

  def set_download_page
    @download_page = DownloadPage.find(params[:download_page_id])
  end
end
