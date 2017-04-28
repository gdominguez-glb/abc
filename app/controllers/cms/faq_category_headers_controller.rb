class Cms::FaqCategoryHeadersController < Cms::BaseController
  before_action :set_faq_category_header, only: [:edit, :update, :destroy]

  include ModelProcessable

  def index
    @faq_category_headers = FaqCategoryHeader.order(:position)
  end

  def new
    @faq_category_header = FaqCategoryHeader.new
  end

  def create
    @faq_category_header = FaqCategoryHeader.new(faq_category_header_params)
    process_create(@faq_category_header, cms_faq_category_headers_path)
  end

  def edit
  end

  def update
    process_update(@faq_category_header, cms_faq_category_headers_path, faq_category_header_params)
  end

  def destroy
    @faq_category_header.destroy
    redirect_to cms_faq_category_headers_path
  end

  private

  def faq_category_header_params
    params.require(:faq_category_header).permit(:name, :position)
  end

  def set_faq_category_header
    @faq_category_header = FaqCategoryHeader.find(params[:id])
  end
end