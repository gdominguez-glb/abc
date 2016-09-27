class Cms::QuestionsController < Cms::BaseController
  before_action :find_question, except: [:index, :new, :create, :published, :drafts, :archived]

  def index
    redirect_to published_cms_questions_path
  end

  def published
    @questions = Question.published.unarchive.includes(:faq_category).page(params[:page])
  end

  def drafts
    @questions = Question.draft.unarchive.includes(:faq_category).page(params[:page])
  end

  def archived
    @questions = Question.archived.includes(:faq_category).page(params[:page])
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
    redirect_to edit_cms_question_path(@question), notice: 'Publish faq successfully!'
  end

  def archive
    @question.archive!
    redirect_to archived_cms_questions_path, notice: 'Archived faq successfully!'
  end

  private

  def question_params
    params.require(:question).permit(:title, :display, :faq_category_id, answer_attributes: [:content_draft])
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
