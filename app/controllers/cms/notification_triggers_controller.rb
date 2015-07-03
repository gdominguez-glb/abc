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

  private

  def notification_trigger_params
    _params = params.require(:notification_trigger).permit(:target_type, :single_user_id, :user_ids, :school_district_admin_user_id, :user_type, :notify_at, :content)
    _params[:user_ids] = _params[:user_ids].split(',')
    _params
  end
end
