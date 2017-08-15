class Cms::RegonlineEventsController < Cms::BaseController
  before_action :find_event_page
  before_action :find_event, except: [:index]

  def index
    @q = @event_page.events.ransack(params[:q])
    @events = @q.result.includes(:regonline_event_header).order('regonline_event_headers.position, display desc, start_date asc').page(params[:page])
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
    _params = params.require(:regonline_event).permit(:title, :display,
      :download_url, :grade_bands, :description, :invisible_at, :regonline_event_header_id,
      :deadline_date, session_types: [], curriculums: [])
    _params[:curriculums] = _params[:curriculums].reject(&:blank?).join(',')
    _params
  end
end
