class Cms::NotificationTriggersController < Cms::BaseController
  def index
    @notification_triggers = NotificationTrigger.page(params[:page])
  end

  def new
    @notification_trigger = NotificationTrigger.new
  end

  def create
    @notification_trigger = NotificationTrigger.new(notification_trigger_params)
    if @notification_trigger.save
      redirect_to cms_notification_triggers_path
    else
      render :new
    end
  end

  def destroy
    notification_trigger = NotificationTrigger.find(params[:id])
    notification_trigger.destroy
    redirect_to cms_notification_triggers_path, notice: 'Delete notifications successfully.'
  end

  include ActiveSupport::NumberHelper
  def target_users_count
    notification_trigger = NotificationTrigger.new(notification_trigger_params)
    text = "Sending notifications to #{number_to_delimited(notification_trigger.calculate_target_users.count)} users"
    render json: { target_users_text:  text}
  end

  private

  def notification_trigger_params
    _params = params.require(:notification_trigger).permit(
      :target_type,
      :single_user_id,
      :user_ids,
      :school_district_admin_user_id,
      :user_type,
      :notify_at,
      :expire_at,
      :content,
      :email,
      :dashboard,
      :product_id,
      :zip_codes
    )
    _params[:user_ids] = _params[:user_ids].split(',')
    _params
  end
end
