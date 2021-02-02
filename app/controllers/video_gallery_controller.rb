class VideoGalleryController < ApplicationController
  before_action :authenticate_user!
  before_action :find_video, only: [:show, :show_description, :play, :unlock, :remove_bookmark]

  helper_method :bought_products?, :can_play_video?, :bookmarked_video?, :teach_eureka_selected?

  include TaxonFilterable

  def index
    params[:taxon_ids] ||= []

    @videos             = Spree::Video.where('1=1')
    @videos             = filter_videos(@videos)

    load_taxonomies(@videos, params[:taxon_ids])

    @videos             = @videos.includes([video_group: [:products], taxons: [:taxonomy]]).order('is_free desc, grade_order asc, module_order asc, lesson_order asc, custom_order asc, title asc').page(params[:page]).per(24)

    @bought_product_ids = fetch_bought_ids(@videos.map(&:products).flatten.compact)
  end

  # TODO: Unused method we need to remove it
  def show
    log_activity(@video)
  end

  # TODO: Unused method we need to remove it
  def show_description
  end

  def play
    respond_to do |format|
      format.html { redirect_to video_gallery_path(@video) }
      format.js { log_activity(@video) }
    end
  end

  def unlock
    @single_product_to_buy = @video.products_to_buy.first
    respond_to do |format|
      format.html {
        if @single_product_to_buy.blank?
          redirect_to '/video_gallery', notice: 'Not available for purchase!'
        elsif @single_product_to_buy.is_beta?
          redirect_to '/video_gallery', notice: 'This product is currently in beta!'
        else
          redirect_to spree.product_path(@single_product_to_buy)
        end
      }
      format.js {}
    end
  end

  # TODO: Unused method we need to remove it
  def bookmark
    @video = Spree::Video.find(params[:id])
    current_spree_user.bookmarks.create(bookmarkable: @video)
  end

  # TODO: Unused method we need to remove it
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
      taxonomies   = taxonomies.where("id in (?) or top_level_in_video = ?",  taxonomy_ids, true)
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

  def teach_eureka_selected?
    teach_eureka_taxon = Spree::Taxon.find_by(name: 'Teach Eureka')
    teach_eureka_taxon && params[:taxon_ids].include?(teach_eureka_taxon.id.to_s)
  end
end
