class Cms::EventTrainingsController < Cms::BaseController
  before_action :set_event_training, only: [:show, :edit, :update, :destroy]

  def index
    @event_trainings = EventTraining.order(:position)
  end

  def new
    @event_training = EventTraining.new
  end

  def create
    @event_training = EventTraining.new(event_training_params)
    if @event_training.save
      redirect_to cms_event_trainings_path, notice: 'Event training created successfully'
    else
      render :new
    end
  end

  def update
    if @event_training.update(event_training_params)
      redirect_to cms_event_trainings_path, notice: 'Update event training successfully'
    else
      render :edit
    end
  end

  def destroy
    @event_training.destroy
    redirect_to cms_event_trainings_path, notice: 'Destroy event training successfully'
  end

  def update_positions
    update_positions_with_klass(EventTraining)
    render nothing: true
  end

  private

  def event_training_params
    params.require(:event_training).permit(:title, :content, :training_type)
  end

  def set_event_training
    @event_training = EventTraining.find(params[:id])
  end
end
