class DownloadPagesController < ApplicationController
  before_action :find_download_page

  helper_method :locked_product?, :filter_grades_option

  def show
    redirect_to root_path if @download_page.blank?

    @products = @download_page.products
    @boughted_products = current_spree_user.products.where(id: @products.map(&:id))
  end

  private

  def find_download_page
    @download_page = DownloadPage.find_by(slug: params[:slug])
  end

  def locked_product?(product)
    !product.free? && !@boughted_products.include?(product)
  end

  def filter_grades_option(product, root_materials)
    if product.is_grades_product? && current_spree_user.grade_option.present?
      root_materials = root_materials.where(name: current_spree_user.grade_option)
    end
    root_materials
  end
end
