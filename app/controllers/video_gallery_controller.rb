class VideoGalleryController < ApplicationController
  before_action :find_video_product, only: [:show, :show_description]

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
  end

  def show_description
  end

  def play
    if current_spree_user
      @video_product = current_spree_user.products.find_by(slug: params[:id])
    end
    @video_product ||= Spree::Product.free.find_by(slug: params[:id])
  end

  private

  def find_video_product
    @video_product = Spree::Product.videos.find_by(slug: params[:id])
  end

  def filter_video_products(video_products)
    if params[:query].present?
      video_products = video_products.where("name like ?", "%#{params[:query]}%")
    end
    if params[:taxon_ids].present?
      taxons = Spree::Taxon.where(id: params[:taxon_ids])
      video_products = video_products.in_taxons(taxons) if !taxons.empty?
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
