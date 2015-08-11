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

  def track
    product_track = current_spree_user.product_tracks.find_or_create_by(product_id: params[:product_id])
    product_track.update(material_id: params[:material_id])
    render nothing: true
  end

  def untrack
    product_track = current_spree_user.product_tracks.find_or_create_by(product_id: params[:product_id])
    material = Spree::Material.find_by(id: params[:material_id])
    if material.blank?
      product_track.destroy
    elsif material.parent.blank?
      product_track.update(material_id: nil)
    else
      product_track.update(material_id: material.parent.id)
    end
    render nothing: true
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
