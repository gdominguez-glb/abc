class MaterialsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_material, only: [:download, :sub]

  def download
    redirect_to @material.material_files.first.file.url
  end

  def download_all
    @product      = current_spree_user.products.find(params[:product_id])
    @download_job = DownloadJob.create(user: current_spree_user, material_ids: @product.materials.roots.map(&:id), status: 'pending')
  end

  def multi_download
    material_ids  = current_spree_user.materials.where(id: params[:material_ids]).pluck(:id)
    @download_job = DownloadJob.create(user: current_spree_user, material_ids: material_ids, status: 'pending')
  end

  def sub
    @product = @material.product
  end
  
  private

  def set_material
    @material = current_spree_user.materials.find(params[:id])
  end
end
