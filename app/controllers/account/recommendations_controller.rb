class Account::RecommendationsController < Account::BaseController
  def show
    recommendation = Recommendation.find(params[:id])
    recommendation.increase_clicks!
    redirect_to recommendation.call_to_action_button_link
  end
end
