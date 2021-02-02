class Cms::EventTrainingsController < Cms::BaseController
  before_action :set_training_type_category
  before_action :set_event_training, only: [:show, :edit, :update, :destroy]

  include ModelProcessable

  def index
    @event_trainings = @training_type_category.event_training_by_header
  end

  def new
    @event_training = EventTraining.new
  end

  def create
    @event_training = EventTraining.new(event_training_params.merge(training_type_category_id: @training_type_category.id))
    process_create(@event_training, cms_training_type_category_event_trainings_path(@training_type_category))
  end

  def update
    process_update(@event_training, cms_training_type_category_event_trainings_path(@training_type_category), event_training_params)
  end

  def destroy
    @event_training.destroy
    redirect_to cms_training_type_category_event_trainings_path(@training_type_category), notice: 'Destroy event training successfully'
  end

  def update_positions
    update_positions_with_klass(@training_type_category.event_trainings)
    render body: nil
  end

  private

  def event_training_params
    params.require(:event_training).permit(:title, :content, :training_type, :position, :category, :event_training_header_id)
  end

  def set_training_type_category
    @training_type_category = TrainingTypeCategory.find(params[:training_type_category_id])
  end

  def set_event_training
    @event_training = @training_type_category.event_trainings.find(params[:id])
  end
end
