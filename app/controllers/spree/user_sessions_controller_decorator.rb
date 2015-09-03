Spree::UserSessionsController.class_eval do
  before_action :authenticate_user!, only: [:become]
  before_filter :require_admin, only: [:become]
  before_filter :can_switch_user, only: [:become]

  def after_sign_in_path_for(resource)
    return unless resource
    return_to = session['spree_user_return_to']
    session['spree_user_return_to'] = nil

    return_to || account_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    '/'
  end

  # Admins can switch to become another user
  def become
    sign_in(:spree_user, @user, bypass: true)
    redirect_to account_path, notice: t('logged_in_as_user', email: @user.email)
  end

  protected

  def account_path
    '/account'
  end

  def require_admin
    return if spree_current_user.admin?
    redirect_to account_path, notice: t('error_messages.permission_denied')
  end

  def can_switch_user
    @user = Spree::User.where(id: params[:id]).first

    unless @user
      redirect_to account_path, notice: t('error_messages.could_not_find_user')
      return
    end

    if current_spree_user == @user
      redirect_to account_path,
                  notice: t('error_messages.could_not_change_to_self',
                            email: current_spree_user.email)
      return
    end

    return unless @user.admin?
    redirect_to account_path,
                notice: t('error_messages.could_not_change_to_admin')
  end
end
