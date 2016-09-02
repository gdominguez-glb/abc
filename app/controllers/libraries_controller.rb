class LibrariesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product, only: [:show, :launch, :download]

  def show
    @library_leafs = @product.library_leafs.includes(:library_items)
  end

  def launch
    @library_item = @product.library_items.find(params[:item_id])
  end

  def download
    @library_item = @product.library_items.find(params[:item_id])
    redirect_to @library_item.attachment.expiring_url(60*60)
  end

  private

  def find_product
    @product = current_spree_user.accessible_products.find_by(slug: params[:id])
    redirect_to root_path if @product.blank?
  end
end
