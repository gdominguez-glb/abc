# frozen_string_literal: true

# Flipbook controller to show, launch and download the pdf if is the case.
class FlipbooksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product, only: %i[show launch download]

  def show
    @flipbook_leafs = @product.flipbook_leafs.includes(:flipbook_items)
  end

  def launch
    @flipbook_item = @product.flipbook_items.find(params[:item_id])
  end

  def download
    @flipbook_item = @product.flipbook_items.find(params[:item_id])
    redirect_to @flipbook_item.attachment.expiring_url(60 * 60)
  end

  private

  def find_product
    @product = current_spree_user.accessible_products.find_by(slug: params[:id])
    redirect_to root_path if @product.blank?
  end
end
