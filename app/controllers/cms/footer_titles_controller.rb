class Cms::FooterTitlesController < Cms::BaseController
  before_action :find_footer_title, except: [:index, :new, :create, :update_positions]

  def index
    @footer_titles = FooterTitle.order('position asc')
  end

  def new
    @footer_title = FooterTitle.new
  end

  def create
    @footer_title = FooterTitle.new(footer_title_params)
    if @footer_title.save
      redirect_to cms_footer_titles_path, notice: 'Created footer title successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @footer_title.update(footer_title_params)
      redirect_to cms_footer_titles_path, notice: 'Updated footer title successfully!'
    else
      render :edit
    end
  end

  def destroy
    @footer_title.destroy
    redirect_to cms_footer_titles_path, notice: 'Deleted footer title successfully!'
  end

  def update_positions
    update_positions_with_klass(FooterTitle)
    render body: nil
  end

  private

  def find_footer_title
    @footer_title = FooterTitle.find(params[:id])
  end

  def footer_title_params
    params.require(:footer_title).permit(:title, :link)
  end
end
