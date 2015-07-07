class Cms::CurriculumsController < Cms::BaseController
  before_action :set_curriculum, only: [:show, :edit, :update, :destroy]

  def index
    @curriculums = Curriculum.page(params[:page])
  end

  def new
    @curriculum = Curriculum.new
  end

  def create
    @curriculum = Curriculum.new(curriculum_params)
    if @curriculum.save
      redirect_to cms_curriculums_path, notice: 'created curriculum successfully'
    else
      render :new
    end
  end

  def update
    if @curriculum.update(curriculum_params)
      redirect_to cms_curriculums_path, notice: 'updated curriculum successfully'
    else
      render :edit
    end
  end

  def destroy
    @curriculum.destroy
    redirect_to cms_curriculums_path, notice: 'deleted curriculum successfully'
  end

  private

  def curriculum_params
    params.require(:curriculum).permit(:name, :position, :visible)
  end

  def set_curriculum
    @curriculum = Curriculum.find(params[:id])
  end
end
