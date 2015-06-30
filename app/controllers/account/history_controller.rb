class Account::HistoryController < Account::BaseController
  def index
    @activities = spree_current_user.activities.order('created_at desc').page(params[:page])
  end

  def remove
    @activity = spree_current_user.activities.find(params[:id])
    @activity.destroy
  end
end
