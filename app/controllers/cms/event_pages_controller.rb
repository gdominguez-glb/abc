class Cms::EventPagesController < Cms::BaseController
  before_action :set_event_page, only: [:show, :edit, :update, :destroy, :publish, :preview, :archive, :unarchive]
  skip_before_action :authenticate_admin_in_cms!
  before_action :authenticate_pd_access_in_cms!

  def index
    redirect_to published_cms_event_pages_path
  end

  def published
    @event_pages = EventPage.published.unarchive.page(params[:page])
  end

  def drafts
    @event_pages = EventPage.draft.unarchive.page(params[:page])
  end

  def archived
    @event_pages = EventPage.archived.page(params[:pages])
  end

  def new
    @event_page = EventPage.new
  end

  def create
    @event_page = EventPage.new(event_page_params)
    if @event_page.save
      redirect_to edit_cms_event_page_path(@event_page), notice: 'Event page created successfully'
    else
      render :new
    end
  end

  def update
    draft_status = @event_page.published? ? :draft_in_progress : :draft
    if @event_page.update(event_page_params.merge(draft_status: draft_status))
      redirect_to edit_cms_event_page_path(@event_page), notice: 'Update event page successfully'
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

  def archive
    @event_page.archive!
    redirect_to archived_cms_event_pages_path, notice: 'Event page archived successfully'
  end

  def unarchive
    @event_page.unarchive!
    redirect_to cms_event_pages_path, notice: 'Event page un-archived successfully'
  end

  private

  def event_page_params
    params.require(:event_page).permit(:title, :page_id, :slug, :display, :regonline_filter, :description_draft, :event_page_type)
  end

  def set_event_page
    @event_page = EventPage.find(params[:id])
  end
end
