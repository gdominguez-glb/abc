class VideoGalleryController < ApplicationController
  before_action :authenticate_user!
  before_action :find_video_product, only: [:show, :show_description]
  before_action :load_taxonomies, only: [:index]

  helper_method :bought_product?, :can_play_video?, :favorited_product?, :can_favorite_product?

  def index
    params[:taxon_ids] ||= []

    @video_products        = Spree::Product.videos.includes([taxons: [:taxonomy]]).page(params[:page])
    @video_products        = filter_video_products(@video_products)

    @bought_product_ids    = fetch_bought_ids(@video_products)
    @favorited_product_ids = fetch_favorite_ids(@video_products)
  end

  def show
    log_activity(@video_product)
  end

  def show_description
  end

  def play
    if current_spree_user
      @video_product = current_spree_user.products.find_by(slug: params[:id])
    end
    @video_product ||= Spree::Product.free.find_by(slug: params[:id])
    log_activity(@video_product)
  end

  private

  def authenticate_user!
    redirect_to spree.login_path, notice: "You must be logged in to view the video gallery." if spree_current_user.blank?
  end

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

  def can_play_video?(product)
    product.free? || (current_spree_user && current_spree_user.products.find_by(id: product.id).present?)
  end

  def favorited_product?(product)
    @favorited_product_ids.include?(product.id)
  end

  def can_favorite_product?(product)
    current_spree_user.blank? ? true : (!current_spree_user.favorite_products.where(product_id: product.id).present?)
  end

  def fetch_bought_ids(products)
    current_spree_user ? current_spree_user.products.where(id: products.map(&:id)).pluck(:id) : []
  end

  def fetch_favorite_ids(products)
    current_spree_user ? current_spree_user.favorite_products.where(product_id: products.map(&:id)).pluck(:product_id) : []
  end

  def load_taxonomies
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end

  def log_activity(product)
    if current_spree_user
      current_spree_user.log_activity(item: product, title: product.name, action: :view)
    end
  end
end
