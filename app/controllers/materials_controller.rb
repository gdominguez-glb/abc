class MaterialsController < ApplicationController
  before_action :set_material, only: [:download, :sub]

  def download
    redirect_to @material.material_files.first.file.url
  end

  def download_all
    @product = Spree::Product.find(params[:product_id])
    @download_job = DownloadJob.create(user: current_spree_user, material_ids: @product.materials.roots.map(&:id), status: 'pending')
  end

  def multi_download
    @download_job = DownloadJob.create(user: current_spree_user, material_ids: params[:material_ids], status: 'pending')
  end

  def sub
    @product = @material.product
  end
  
  private

  def set_material
    @material = Spree::Material.find(params[:id])
  end
end
