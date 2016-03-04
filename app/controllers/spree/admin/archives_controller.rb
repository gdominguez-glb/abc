class Spree::Admin::ArchivesController < Spree::Admin::BaseController
  def index
    @archived_products = Spree::Product.where(archived: true).page(params[:page])
  end
end
