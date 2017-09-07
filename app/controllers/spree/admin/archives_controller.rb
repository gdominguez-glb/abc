class Spree::Admin::ArchivesController < Spree::Admin::BaseController
  def index
    @archived_products = Spree::Product.search_by_text(params[:q]).where(archived: true).page(params[:page])
  end
end
