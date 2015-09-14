class Account::HelpController < Account::BaseController
  def index
    @faq_categories = FaqCategory.displayable.includes(:questions)

    @help_items = HelpItem.displayable
  end

  def qa
    @question = Question.find(params[:id])
  end

  def item
    @help_item = HelpItem.find(params[:id])
  end
end
