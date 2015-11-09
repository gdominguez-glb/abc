class Cms::QuestionsController < Cms::BaseController
  before_action :find_question, except: [:index, :new, :create]

  def index
    @questions = Question.includes(:faq_category).page(params[:page])
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to cms_questions_path, notice: 'Created question successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to cms_questions_path, notice: 'Updated question successfully!'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to cms_questions_path, notice: 'Deleted question successfully!'
  end

  private

  def question_params
    params.require(:question).permit(:title, :display, :faq_category_id, answer_attributes: [:content])
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
