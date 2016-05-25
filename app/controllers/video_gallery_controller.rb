class VideoGalleryController < ApplicationController
  before_action :authenticate_user!
  before_action :find_video, only: [:show, :show_description, :play, :unlock, :remove_bookmark]

  helper_method :bought_products?, :can_play_video?, :bookmarked_video?

  include TaxonFilterable

  def index
    params[:taxon_ids] ||= []

    @videos             = Spree::Video.where('1=1')
    @videos             = filter_videos(@videos)

    load_taxonomies(@videos, params[:taxon_ids])

    @videos             = @videos.includes([video_group: [:products], taxons: [:taxonomy]]).order('is_free desc, grade_order asc, module_order asc, lesson_order asc, title asc').page(params[:page])

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

  def load_taxonomies(videos, selected_taxon_ids)
    taxonomies = Spree::Taxonomy.show_in_video
    if selected_taxon_ids.present?
      taxon_ids    = Spree::VideoClassification.where(video_id: @videos.pluck(:id)).pluck('distinct(taxon_id)')
      taxonomy_ids = Spree::Taxon.where(id: taxon_ids).pluck('distinct(taxonomy_id)')
      taxonomies   = taxonomies.where(id: taxonomy_ids + [group_taxonomy_id])
    else
      taxonomies = taxonomies.top_level_in_video
    end
    @taxonomies = taxonomies.includes(root: :children)
  end

  def log_activity(video)
    if current_spree_user
      current_spree_user.log_activity(item: video, title: video.title, action: :view)
    end
  end

  def group_taxonomy_id
    Spree::Taxonomy.show_in_video.find_by(name: 'Group').try(:id)
  end
end
