class MaterialsController < ApplicationController
  before_action :set_material, only: [:download, :sub]

  def download
    redirect_to @material.material_files.first.file.url
  end

  def sub
    @product = @material.product
  end
  
  private

  def set_material
    @material = Spree::Material.find(params[:id])
  end
end
