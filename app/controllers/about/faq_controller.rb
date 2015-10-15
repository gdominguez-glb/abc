class About::FAQController < About::BaseController
  def index
    @faq_categories = FaqCategory.displayable.includes(:questions)
  end

  def qa
    @question = Question.find(params[:id])
  end
end
