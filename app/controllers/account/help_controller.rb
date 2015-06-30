class Account::HelpController < Account::BaseController
  def index
    @qa = Question.displayable
  end

  def qa
    @question = Question.find(params[:id])
  end
end
