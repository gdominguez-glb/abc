class Cms::TrainingTypeCategoriesController < Cms::BaseController
  before_action :set_training_type_category, only: [:show, :edit, :update, :destroy]

  def index
    @training_type_categories = TrainingTypeCategory.all
  end

  def new
    @training_type_category = TrainingTypeCategory.new
  end

  def create
    @training_type_category = TrainingTypeCategory.new(training_type_category_params)
    if @training_type_category.save
      redirect_to cms_training_type_categories_path, notice: 'Event training category created successfully'
    else
      render :new
    end
  end

  def update
    if @training_type_category.update(training_type_category_params)
      redirect_to cms_training_type_categories_path, notice: 'Update event training category successfully'
    else
      render :edit
    end
  end

  def destroy
    @training_type_category.destroy
    redirect_to cms_training_type_categories_path, notice: 'Destroy event training category successfully'
  end

  private

  def training_type_category_params
    params.require(:training_type_category).permit(:title, :description, :is_default, :slug)
  end

  def set_training_type_category
    @training_type_category = TrainingTypeCategory.find(params[:id])
  end
end
