class About::FaqController < About::BaseController
  def index
    @faq_categories = FaqCategory.displayable.includes(:questions).order('position asc')
    @page_title = 'FAQs'
  end

  def qa
    @question = Question.find(params[:id])
    @page_title = "FAQ - #{@question.title}"
  end
end
