class Cms::RegonlineEventHeadersController < Cms::BaseController
  before_action :find_event_page
  before_action :load_regonline_event_header, only: [:edit, :update, :destroy]

  include ModelProcessable

  def index
    @regonline_event_headers = @event_page.regonline_event_headers.all
  end

  def new
    @regonline_event_header = RegonlineEventHeader.new
  end

  def create
    @regonline_event_header = RegonlineEventHeader.new(regonline_event_header_params.merge(event_page_id:  @event_page.id))
    process_create(@regonline_event_header, cms_event_page_regonline_event_headers_path(@event_page))
  end

  def edit; end

  def update
    process_update(@regonline_event_header, cms_event_page_regonline_event_headers_path(@event_page), regonline_event_header_params)
  end

  def destroy
    @regonline_event_header.destroy
    redirect_to cms_event_page_regonline_event_headers_path(@event_page), notice: 'Destroyed successfully'
  end

  private

  def regonline_event_header_params
    params.require(:regonline_event_header).permit(:name, :position)
  end

  def find_event_page
    @event_page = EventPage.find(params[:event_page_id])
  end

  def load_regonline_event_header
    @regonline_event_header = @event_page.regonline_event_headers.find(params[:id])
  end
end
