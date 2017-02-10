class Cms::EventTrainingHeadersController < Cms::BaseController
  before_action :set_training_type_category
  before_action :set_event_training, only: [:show, :edit, :update, :destroy]

  include EventTraininable

  def index
    @event_training_headers = @training_type_category.event_training_headers.order(:position)
  end

  def new
    @event_training_header = EventTrainingHeader.new
  end

  def create
    @event_training_header = EventTrainingHeader.new(event_training_header_params.merge(training_type_category_id: @training_type_category.id))
    process_create(@event_training_header, cms_training_type_category_event_training_headers_path(@training_type_category))
  end

  def edit
  end

  def update
    process_update(@event_training_header, cms_training_type_category_event_training_headers_path(@training_type_category), event_training_header_params)
  end

  def destroy

  end

  private

  def event_training_header_params
    params.require(:event_training_header).permit(:name, :position)
  end

  def set_training_type_category
    @training_type_category = TrainingTypeCategory.find(params[:training_type_category_id])
  end

  def set_event_training
    @event_training_header = @training_type_category.event_training_headers.find(params[:id])
  end
end