class Cms::RegonlineEventsController < Cms::BaseController
  before_action :find_event_page
  before_action :find_event, except: [:index]

  def index
    @events = @event_page.events.page(params[:page])
  end

  def edit
  end

  def update
    if @event.update_attributes(event_params)
      redirect_to cms_event_page_regonline_events_path(@event_page)
    else
      render :edit
    end
  end

  private

  def find_event_page
    @event_page = EventPage.find(params[:event_page_id])
  end

  def find_event
    @event = RegonlineEvent.find(params[:id])
  end

  def event_params
    params.require(:regonline_event).permit(:title, :display, :download_url, :grade_bands, :description, session_types: [])
  end
end
