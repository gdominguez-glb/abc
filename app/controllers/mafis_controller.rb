class MafisController < ApplicationController

  def show
    @mafis_product = MafisProduct.find_by(record_id: params[:record_id])
    redirect_to not_found_path and return if @mafis_product.blank?
  end
end
