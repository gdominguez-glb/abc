class VideoGalleryController < ApplicationController
  before_action :authenticate_user!
  before_action :find_video, only: [:show, :show_description, :play, :unlock]
  before_action :load_taxonomies, only: [:index]

  helper_method :bought_products?, :can_play_video?, :bookmarked_video?

  def index
    params[:taxon_ids] ||= []

    @videos        = Spree::Video.includes([video_group: [:products], taxons: [:taxonomy]]).uniq.page(params[:page])
    @videos        = filter_videos(@videos)

    @bought_product_ids    = fetch_bought_ids(@videos.map(&:products).flatten.compact)
  end

  def show
    log_activity(@video)
  end

  def show_description
  end

  def play
    log_activity(@video)
  end

  def unlock
  end

  def bookmark
    video = Spree::Video.find(params[:id])
    current_spree_user.bookmarks.create(bookmarkable: video)
  end

  private

  def authenticate_user!
    redirect_to spree.login_path, notice: "You must be logged in to view the video gallery." if spree_current_user.blank?
  end

  def find_video
    @video = Spree::Video.find(params[:id])
  end

  def filter_videos(videos)
    if params[:query].present?
      videos = videos.where("title like ?", "%#{params[:query]}%")
    end
    if params[:taxon_ids].present?
      taxons = Spree::Taxon.where(id: params[:taxon_ids])
      videos = videos.with_taxons(taxons) if !taxons.empty?
    end
    videos
  end

  def bought_products?(products)
    (@bought_product_ids & products.map(&:id)).present?
  end

  def can_play_video?(video)
    video.is_free? || (current_spree_user && current_spree_user.products.find_by(id: video.product.id).present?)
  end

  def bookmarked_video?(video)
    current_spree_user.bookmarks.where(bookmarkable: video).present?
  end

  def fetch_bought_ids(products)
    current_spree_user ? current_spree_user.products.where(id: products.map(&:id)).pluck(:id) : []
  end

  def load_taxonomies
    @taxonomies = Spree::Taxonomy.show_in_store.includes(root: :children)
  end

  def log_activity(video)
    if current_spree_user
      current_spree_user.log_activity(item: video, title: video.title, action: :view)
    end
  end
end
