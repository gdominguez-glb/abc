class MaterialsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_material, only: [:download, :preview, :bookmark, :remove_bookmark]
  before_action :set_product, only: [:download_all, :multi_download]

  def download
    log_activity(@material, "Download #{@material.name}")
    redirect_to not_found_path and return if @material.material_files.count == 0

    respond_to do |format|
      format.html {
        redirect_to @material.material_files.first.signed_url
      }
      format.js {
        if @material.material_files.count == 1 && @material.children.count == 0
          @download_url = @material.material_files.first.signed_url
        else
          @download_job = DownloadJob.create(user: current_spree_user, material_ids: [@material.id], status: 'pending')
        end
      }
    end
  end

  def download_all
    log_activity(@product, "Download All Files in #{@product.name}")

    @download_job = DownloadJob.create(user: current_spree_user, material_ids: @product.materials.roots.map(&:id), status: 'pending')
  end

  def multi_download
    log_activity(@product, "Download Multiple Files in #{@product.name}")

    material_ids  = @product.materials.where(id: params[:material_ids]).pluck(:id)
    @download_job = DownloadJob.create(user: current_spree_user, material_ids: material_ids, status: 'pending')
  end

  def track
    product_track = current_spree_user.product_tracks.find_or_create_by(product_id: params[:product_id])
    product_track.update(material_id: params[:material_id])
    render body: nil
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
    render body: nil
  end

  def preview
    respond_to do |format|
      format.js {}
      format.html {
        redirect_to @material.material_files.first.preview_signed_url
      }
    end
  end

  def bookmark
    current_spree_user.bookmarks.find_or_create_by(bookmarkable: @material)
  end

  def remove_bookmark
    current_spree_user.bookmarks.find_by(bookmarkable: @material).try(:destroy)
  end

  private

  def set_material
    @material = Spree::Material.find(params[:id])
    redirect_to not_found_path and return if @material.product.blank?
    if !(@material.product.free? || current_spree_user.accessible_products.where(id: @material.product_id).exists?)
      flash[:error] = "Your're not allowed to view the file."
      redirect_to root_path and return
    end
    @product = @material.product
  end

  def set_product
    product = Spree::Product.find(params[:product_id])
    if product.free?
      @product = product
    else
      @product = current_spree_user.accessible_products.find(product.id)
    end
  end

  def log_activity(item, title)
    current_spree_user.log_activity(title: title, item: item, action: 'download')
  end
end
