class Cms::EventPagesController < Cms::BaseController
  before_action :set_event_pages, only: [:index, :published, :drafts, :archived]
  before_action :set_event_page, only: [:show, :edit, :update, :destroy, :publish, :preview]

  def index
    redirect_to published_cms_event_pages_path
  end

  def published
  end

  def drafts
  end

  def archived
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

  def import_events
    RegonlineWorker.perform_async
  end

  def publish
    @event_page.publish!
    redirect_to cms_event_pages_path, notice: 'Event page published successfully'
  end

  private

  def event_page_params
    params.require(:event_page).permit(:title, :page_id, :slug, :display, :regonline_filter, :description, :event_page_type)
  end

  def set_event_page
    @event_page = EventPage.find(params[:id])
  end

  def set_event_pages
    @event_pages = EventPage.page(params[:page])
  end
end
