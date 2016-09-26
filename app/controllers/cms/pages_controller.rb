module Cms
  # PagesController
  class PagesController < Cms::BaseController
    before_action :set_page_search_form, only: [:index, :published, :drafts, :published_category, :drafts_category, :archived, :archived_category, :search]
    before_action :set_page, only: [:show, :edit, :update, :destroy,
                                    :update_tiles, :publish, :preview, :archive]

    def index
      redirect_to published_cms_pages_path
    end

    def published
    end

    def published_category
      @pages = Page.published.unarchive.by_category(params[:category]).order('group_name ASC, position ASC').page(params[:page]).per(10)
    end

    def drafts
    end

    def drafts_category
      @pages = Page.draft.unarchive.by_category(params[:category]).order('group_name ASC, position ASC').page(params[:page]).per(10)
    end

    def search
      @pages = @q.result.order('group_name ASC, position ASC').page(params[:page]).per(10)
    end

    def archived
    end

    def archived_category
      @pages = Page.archived.by_category(params[:category]).order('group_name ASC, position ASC').page(params[:page]).per(10)
    end

    def show
    end

    def new
      @page = Page.new
    end

    def edit
      @page.tiles ||= { rows: [] }
      @page.tiles[:rows].sort_by! { |row| row[:position].to_i }
    end

    def create
      tile_rows = (params[:tiles] || {}).values
      @page = Page.new(page_params.merge(tiles: { rows: tile_rows}))

      if @page.save
        flash[:notice] = 'Page was successfully created.'
        respond_to do |format|
          format.html { redirect_to [:cms, @page] }
          format.js
        end
      else
        respond_to do |format|
          format.html{ render :new }
          format.js
        end
      end
    end

    def update
      tile_rows = (params[:tiles] || {}).values
      draft_status = @page.published? ? :draft_in_progress : :draft
      if @page.update(page_params.merge(tiles: { rows: tile_rows}, draft_status: draft_status))
        flash[:notice] = 'Page was successfully updated.'
        respond_to do |format|
          format.html{ redirect_to edit_cms_page_path(@page) }
          format.js
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.js
        end
      end
    end

    def destroy
      @page.destroy
      redirect_to cms_pages_url, notice: 'Page was successfully destroyed.'
    end

    def process_tiles
      tiles = nil
      if params[:page].try('[]', :tiles).present?
        tiles = { rows: params[:page][:tiles][:rows].values }
      end
      page = Page.new(tiles: tiles)
      page.send(:generate_page_from_tiles)
      render json: { body: page.body }
    end

    def publish
      @page.publish!
      redirect_to edit_cms_page_path(@page), notice: 'Published page successfully!'
    end

    def archive
      @page.archive!
      redirect_to archived_cms_pages_path, notice: 'Archived page successfully!'
    end

    def preview
      render layout: 'application'
    end

    private

    def set_page_search_form
      @q = Page.ransack(params[:q])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list
    # through.
    def page_params
      params.require(:page).permit(:title, :seo_content, :slug, :group_name,
                                   :keywords, :description,
                                   :sub_group_name, :position, :layout, :body, :body_draft,
                                   :visible, :curriculum_id, :group_root,
                                   :show_in_nav, :show_in_footer, tiles: {})
    end
  end
end
