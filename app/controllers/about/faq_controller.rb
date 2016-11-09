class About::FaqController < About::BaseController
  def index
    @faq_categories = FaqCategory.displayable.includes(:questions).order('position asc')
    @page_title = 'FAQs'
  end

  def qa
    question_with_id = Question.find_by(id: params[:id])
    if question_with_id.present?
      redirect_to about_qa_path(id: question_with_id.slug) and return
    end
    @question = Question.find_by(slug: params[:id])
    @page_title = "FAQ - #{@question.title}"
  end
end
