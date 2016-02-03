class VideoGalleryController < ApplicationController
  before_action :authenticate_user!
  before_action :find_video, only: [:show, :show_description, :play, :unlock, :remove_bookmark]
  before_action :load_taxonomies, only: [:index]

  helper_method :bought_products?, :can_play_video?, :bookmarked_video?

  include TaxonFilterable

  def index
    params[:taxon_ids] ||= []

    @videos             = Spree::Video.order('spree_videos.title asc')
    @videos             = filter_videos(@videos)
    @videos             = @videos.includes([video_group: [:products], taxons: [:taxonomy]]).page(params[:page])

    @bought_product_ids = fetch_bought_ids(@videos.map(&:products).flatten.compact)
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
    @video = Spree::Video.find(params[:id])
    current_spree_user.bookmarks.create(bookmarkable: @video)
  end

  def remove_bookmark
    @video = Spree::Video.find(params[:id])
    current_spree_user.bookmarks.find_by(bookmarkable: @video).try(:destroy)
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
      videos = videos.where("title ilike ?", "%#{params[:query]}%")
    end
    filter_by_taxons(Spree::Video, videos, params[:taxon_ids])
  end

  def bought_products?(products)
    (@bought_product_ids & products.map(&:id)).present?
  end

  def can_play_video?(video)
    video.is_free? || (current_spree_user && current_spree_user.accessible_products.where(id: video.products.map(&:id)).present?)
  end

  def bookmarked_video?(video)
    current_spree_user.bookmarks.where(bookmarkable: video).present?
  end

  def fetch_bought_ids(products)
    current_spree_user ? current_spree_user.accessible_products.where(id: products.map(&:id)).pluck(:id) : []
  end

  def load_taxonomies
    @taxonomies = Spree::Taxonomy.show_in_video.includes(root: :children)
  end

  def log_activity(video)
    if current_spree_user
      current_spree_user.log_activity(item: video, title: video.title, action: :view)
    end
  end
end
