Spree::UserSessionsController.class_eval do
  before_action :authenticate_user!, only: [:become]
  before_filter :require_admin, only: [:become]
  before_filter :can_switch_user, only: [:become]

  # Admins can switch to become another user
  def become
    sign_in(:spree_user, @user, bypass: true)
    redirect_to main_app.account_root_path, notice: t('logged_in_as_user', email: @user.email)
  end

  protected

  def require_admin
    return if spree_current_user.admin?
    redirect_to main_app.account_root_path, notice: t('error_messages.permission_denied')
  end

  def can_switch_user
    @user = Spree::User.find_by(id: params[:id])

    unless @user
      redirect_to main_app.account_root_path, notice: t('error_messages.could_not_find_user')
      return
    end

    if current_spree_user == @user
      redirect_to main_app.account_root_path,
                  notice: t('error_messages.could_not_change_to_self',
                            email: current_spree_user.email)
      return
    end

    return unless @user.admin?
    redirect_to main_app.account_root_path,
                notice: t('error_messages.could_not_change_to_admin')
  end
end
