class VideoGalleryController < ApplicationController
  before_action :load_filter_data, only: [:index]

  def index
    @video_products = Spree::Product.videos.page(params[:page]).per(params[:per_page])
    @video_products = filter_video_products(@video_products)
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
    if params[:grade_id].present?
      video_products = video_products.where(grade_id: params[:grade_id])
    end
    if params[:curriculum_id].present?
      video_products = video_products.where(curriculum_id: params[:curriculum_id])
    end
    video_products
  end
end
