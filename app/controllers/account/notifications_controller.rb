class Account::NotificationsController < Account::BaseController
  def read
    @notification = current_spree_user.notifications.find(params[:id])
    @notification.mark_as_read!
  end
end
