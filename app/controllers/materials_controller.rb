class MaterialsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_material, only: [:download]

  def download
    if @material.material_files.count == 1 && @material.children.count == 0
      @download_url = @material.material_files.first.file.expiring_url(60*60*60)
    else
      @download_job = DownloadJob.create(user: current_spree_user, material_ids: [@material.id], status: 'pending')
    end
  end

  def download_all
    @product      = current_spree_user.products.find(params[:product_id])
    @download_job = DownloadJob.create(user: current_spree_user, material_ids: @product.materials.roots.map(&:id), status: 'pending')
  end

  def multi_download
    material_ids  = current_spree_user.materials.where(id: params[:material_ids]).pluck(:id)
    @download_job = DownloadJob.create(user: current_spree_user, material_ids: material_ids, status: 'pending')
  end

  private

  def set_material
    material = Spree::Material.find(params[:id])
    if material.product.free?
      @material = material
    else
      @material = current_spree_user.materials.reorder('spree_materials.id asc').find(material.id)
    end
  end
end
