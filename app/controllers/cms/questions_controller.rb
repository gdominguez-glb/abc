class Cms::QuestionsController < Cms::BaseController
  before_action :find_questions_search_form, only: [:index, :published, :drafts, :archived]
  before_action :find_question, except: [:index, :new, :create, :published, :drafts, :archived]

  def index
    redirect_to published_cms_questions_path
  end

  def published
  end

  def drafts
  end

  def archived
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
    draft_status = @question.published? ? :draft_in_progress : :draft
    if @question.update(question_params.merge(draft_status: draft_status))
      redirect_to cms_questions_path, notice: 'Updated question successfully!'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to cms_questions_path, notice: 'Deleted question successfully!'
  end

  def publish
    @question.publish!
    redirect_to cms_questions_path, notice: 'Publish faq successfully!'
  end

  private

  def question_params
    params.require(:question).permit(:title, :display, :faq_category_id, answer_attributes: [:content_draft])
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def find_questions_search_form
    @questions = Question.includes(:faq_category).page(params[:page])
  end
end
