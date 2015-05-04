class VideoGalleryController < ApplicationController
  before_action :load_filter_data, only: [:index]

  helper_method :bought_product?, :preference_video_player, :can_play_video?

  def index
    @video_products = Spree::Product.videos.page(params[:page]).per(params[:per_page])
    @video_products = filter_video_products(@video_products)

    @bought_product_ids = current_spree_user ? current_spree_user.products.where(id: @video_products.map(&:id)).pluck(:id) : []
  end

  def show
    @video_product = Spree::Product.videos.find_by(slug: params[:id])
  end

  def show_description
    @video_product = Spree::Product.videos.find_by(slug: params[:id])
  end

  def play
    if current_spree_user
      @video_product = current_spree_user.products.find_by(slug: params[:id])
    end
    @video_product ||= Spree::Product.free.find_by(slug: params[:id])
  end

  def set_player
    if current_spree_user
      current_spree_user.update(preference_video_player: params[:player])
    else
      session[:preference_video_player] = params[:player]
    end
    render nothing: true
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

  def preference_video_player
    (spree_current_user.blank? ? session[:preference_video_player] : spree_current_user.preference_video_player) || 'vimeo'
  end

  def can_play_video?(product)
    product.free? || (current_spree_user && current_spree_user.products.find_by(id: product.id).present?)
  end
end
