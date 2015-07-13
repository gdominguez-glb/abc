class Cms::EventPagesController < Cms::BaseController
  before_action :set_event_page, only: [:show, :edit, :update, :destroy]

  def index
    @event_pages = EventPage.page(params[:page])
  end

  def new
    @event_page = EventPage.new
  end

  def create
    @event_page = EventPage.new(event_page_params)
    if @event_page.save
      redirect_to cms_event_pages_path, notice: 'Event page created successfully'
    else
      render :new
    end
  end

  def update
    if @event_page.update(event_page_params)
      redirect_to cms_event_pages_path, notice: 'Update event page successfully'
    else
      render :edit
    end
  end

  def destroy
    @event_page.destroy
    redirect_to cms_event_pages_path, notice: 'Destroy event page successfully'
  end

  private

  def event_page_params
    params.require(:event_page).permit(:title, :page_id, :slug, :display, :regonline_filter)
  end

  def set_event_page
    @event_page = EventPage.find(params[:id])
  end
end
