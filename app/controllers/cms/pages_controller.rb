module Cms
  # PagesController
  class PagesController < Cms::BaseController
    before_action :set_page, only: [:show, :edit, :update, :destroy,
                                    :product_marketing_editor, :update_tiles]

    def index
      @q = Page.ransack(params[:q])
      @pages = @q.result.order('group_name ASC, position ASC').page(params[:page]).per(10)
    end

    def show
    end

    def new
      @page = Page.new
    end

    def edit
    end

    def create
      tile_rows = (params[:tiles] || {}).values
      @page = Page.new(page_params.merge(tiles: { rows: tile_rows}))

      if @page.save
          respond_to do |format|
            format.html { redirect_to [:cms, @page], notice: 'Page was successfully created.' }
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
      if @page.update(page_params.merge(tiles: { rows: tile_rows}))
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

    def product_marketing_editor
      @page.tiles ||= { rows: [] }
      @page.tiles[:rows].sort_by! { |row| row[:position]}
    end

    def update_tiles
      tiles = nil
      if params[:page].try('[]', :tiles).present?
        tiles = { rows: params[:page][:tiles][:rows].values }
      end
      @page.update(tiles: tiles)
      flash[:notice] = "Page was succesfully updated."
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

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list
    # through.
    def page_params
      params.require(:page).permit(:title, :seo_content, :slug, :group_name,
                                   :keywords, :description,
                                   :sub_group_name, :position, :layout, :body,
                                   :visible, :curriculum_id, :group_root,
                                   :show_in_nav, :show_in_footer, tiles: {})
    end
  end
end
