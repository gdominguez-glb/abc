class FaqController < About::BaseController
  def index
    @faq_category_headers = FaqCategoryHeader.list_all(true)
    @page_title = 'FAQs'
  end

  def qa
    question_with_id = Question.find_by(id: params[:id])
    if question_with_id.present?
      redirect_to qa_path(id: question_with_id.slug) and return
    end
    @question = Question.find_by(slug: params[:id])

    redirect_to not_found_path and return if @question.nil?

    @page_title = "FAQ - #{@question.title}"
  end
end
