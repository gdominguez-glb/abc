Spree::UserSessionsController.class_eval do
  before_action :authenticate_user!, only: [:become]
  before_filter :require_admin, only: [:become]
  before_filter :can_switch_user, only: [:become]
  skip_before_action :accepted_terms, only: [:destroy]

  # override this action to remove login flash message
  def create
    authenticate_spree_user!

    if spree_user_signed_in?
      respond_to do |format|
        format.html {
          redirect_back_or_default(after_sign_in_path_for(spree_current_user))
        }
        format.js {
          render :json => {:user => spree_current_user,
                           :ship_address => spree_current_user.ship_address,
                           :bill_address => spree_current_user.bill_address}.to_json
        }
      end
    else
      respond_to do |format|
        format.html {
          flash.now[:error] = t('devise.failure.invalid')
          render :new
        }
        format.js {
          render :json => { error: t('devise.failure.invalid') }, status: :unprocessable_entity
        }
      end
    end
  end

  def lti
    begin
      json_data = Cypher.decrypt spree_user_param[:id]
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      render body: 'Invalid id', status: 500 and return
    end
    data = JSON.parse json_data

    token = Doorkeeper::AccessToken.find_by token: data['token']
    render body: 'Token expired', status: 500 and return if token.blank? || token.expired?

    user = Spree::User.find_by id: data['id']
    render body: 'User not found', status: 500 and return if user.blank?

    sign_in user

    redirect_to spree_user_param['redirect_to']
  end

  # override to remove flash message
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    yield if block_given?
    respond_to_on_destroy
  end

  # Admins can switch to become another user
  def become
    session[:ghost_login_admin_id] = current_spree_user.id
    session[:ghost_back_path] = request.referrer
    sign_in(:spree_user, @user, bypass: true)
    redirect_to main_app.account_root_path, notice: t('logged_in_as_user', email: @user.email)
  end

  protected

  def require_admin
    return if spree_current_user.admin? || current_spree_user.has_csr_role? || current_spree_user.has_account_sales_role?
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

    return unless (@user.admin? || @user.has_csr_role?)
    redirect_to main_app.account_root_path,
                notice: t('error_messages.could_not_change_to_admin')
  end

  def verify_signed_out_user
    if all_signed_out?
      respond_to_on_destroy
    end
  end

  def spree_user_param
    params.
      require(:spree_user).
      permit(:id, :redirect_to)
  end
end
