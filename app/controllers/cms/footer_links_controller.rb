class Cms::FooterLinksController < Cms::BaseController
  before_action :find_footer_title
  before_action :find_footer_link, except: [:index, :new, :create, :update_positions]

  def index
    @footer_links = @footer_title.footer_links
  end

  def new
    @footer_link = FooterLink.new
  end

  def create
    @footer_link = @footer_title.footer_links.new(footer_link_params)
    if @footer_link.save
      redirect_to cms_footer_title_footer_links_path(@footer_title), notice: 'Created footer link successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @footer_link.update(footer_link_params)
      redirect_to cms_footer_title_footer_links_path(@footer_title), notice: 'Updated footer link successfully!'
    else
      render :edit
    end
  end

  def destroy
    @footer_link.destroy
    redirect_to cms_footer_title_footer_links_path(@footer_title), notice: 'Deleted footer link successfully!'
  end

  def update_positions
    update_positions_with_klass(FooterLink)
    render body: nil
  end

  private

  def find_footer_title
    @footer_title = FooterTitle.find(params[:footer_title_id])
  end

  def find_footer_link
    @footer_link = FooterLink.find(params[:id])
  end

  def footer_link_params
    params.require(:footer_link).permit(:name, :link)
  end
end
