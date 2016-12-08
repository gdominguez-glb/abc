class FamisController < ApplicationController

  def show
    @famis_product = FamisProduct.find_by(record_id: params[:record_id])
    redirect_to not_found_path and return if @famis_product.blank?
  end
end
