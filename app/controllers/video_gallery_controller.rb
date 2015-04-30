class VideoGalleryController < ApplicationController
  before_action :load_filter_data, only: [:index]

  helper_method :bought_product?

  def index
    @video_products = Spree::Product.videos.page(params[:page]).per(params[:per_page])
    @video_products = filter_video_products(@video_products)

    @bought_product_ids = current_spree_user ? current_spree_user.products.where(id: @video_products.map(&:id)).pluck(:id) : []
  end

  def show
    @video_product = Spree::Product.videos.find_by(params[:slug])
  end

  private

  def load_filter_data
    @grades = Spree::Grade.order('position asc')
    @selected_grade = Spree::Grade.find_by(id: params[:grade_id])

    @curriculums = Spree::Curriculum.order('position asc')
    @selected_curriculum = Spree::Curriculum.find_by(id: params[:curriculum_id])
  end

  def filter_video_products(video_products)
    if params[:query].present?
      video_products = video_products.where("name like ?", "%#{params[:query]}%")
    end
    if params[:grade_id].present?
      video_products = video_products.where(grade_id: params[:grade_id])
    end
    if params[:curriculum_id].present?
      video_products = video_products.where(curriculum_id: params[:curriculum_id])
    end
    video_products
  end

  def bought_product?(product)
    @bought_product_ids.include?(product.id)
  end
end
