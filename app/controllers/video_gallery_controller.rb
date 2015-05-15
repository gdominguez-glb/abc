class VideoGalleryController < ApplicationController
  before_action :load_filter_data, only: [:index]

  helper_method :bought_product?, :preference_video_player, :can_play_video?, :favorited_product?, :can_favorite_product?

  def index
    params[:taxon_ids] ||= []
    @taxonomies = Spree::Taxonomy.includes(root: :children)

    @video_products = Spree::Product.videos.page(params[:page]).per(params[:per_page])
    @video_products = filter_video_products(@video_products)

    @bought_product_ids = current_spree_user ? current_spree_user.products.where(id: @video_products.map(&:id)).pluck(:id) : []
    @favorited_product_ids = current_spree_user ? current_spree_user.favorite_products.where(product_id: @video_products.map(&:id)).pluck(:product_id) : []
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

  def add_favorite
    if current_spree_user
      product = Spree::Product.find_by(slug: params[:id])
      @favorite_product = current_spree_user.favorite_products.create(product_id: product.id)
    end
  end

  private

  def load_filter_data
    @grades = Spree::Grade.order('position asc')
    @selected_grade = Spree::Grade.find_by(id: params[:grade_id])
  end

  def filter_video_products(video_products)
    if params[:query].present?
      video_products = video_products.where("name like ?", "%#{params[:query]}%")
    end
    if params[:taxon_id].present?
      @taxon = Spree::Taxon.friendly.find(params[:taxon_id])
      video_products = video_products.in_taxon(@taxon) if @taxon
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

  def favorited_product?(product)
    @favorited_product_ids.include?(product.id)
  end

  def can_favorite_product?(product)
    current_spree_user.blank? ? true : (!current_spree_user.favorite_products.where(product_id: product.id).present?)
  end
end
