class Cms::PagesController < Cms::BaseController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def index
    @pages = Page.order('group_name ASC, position ASC').page(params[:page]).per(10)
  end

  def show
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to [:cms, @page], notice: 'Page was successfully created.'
    else
      render :new
    end
  end

  def update
    if @page.update(page_params)
      redirect_to [:cms, @page], notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to cms_pages_url, notice: 'Page was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title, :seo_content, :slug, :group_name, :sub_group_name, :position, :layout, :body, :visible, :curriculum_id, :group_root, :show_in_nav, :show_in_footer)
    end
end
