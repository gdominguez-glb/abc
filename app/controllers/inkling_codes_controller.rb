class InklingCodesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product, only: [:show]

  def show
    @inkling_code = @product.inkling_code
  end

  private

  def find_product
    @product = Spree::Product.find_by(slug: params[:id])
    redirect_to root_path if @product.blank?
  end
end
