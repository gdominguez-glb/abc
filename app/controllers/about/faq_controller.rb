class About::FaqController < About::BaseController
  def index
    @faq_categories = FaqCategory.displayable.includes(:questions).order('position asc')
  end

  def qa
    @question = Question.find(params[:id])
  end
end
