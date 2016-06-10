class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :ghost_login?, :admin_ghost_login?

  before_action :accepted_terms
  skip_before_action :accepted_terms, only: [:logout]

  if Rails.env.qa? || Rails.env.staging? || Rails.env.production?
    def default_url_options(options={})
      options.merge({ protocol: "https" })
    end
  end

  def current_ability
    @current_ability ||= Spree::Ability.new(current_user)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :root, alert: exception.message
  end

  before_action :custom_authenticate, if: :require_http_basic_auth

  def custom_authenticate
    authenticate_or_request_with_http_basic('Not what you were looking for? Please visit greatminds.net.') do |username, password|
      if(username == ENV['auth_username'] && password == ENV['auth_password'])
        true
      else
        redirect_to '/auth_error.html'
      end
    end
  end

  def signed_in_root_path(resource_or_scope)
    if resource_or_scope.is_a?(Spree::User)
      path_for_spree_user(resource_or_scope)
    else
      '/'
    end
  end

  def after_sign_out_path_for(_resource_or_scope)
    '/'
  end

  def path_for_spree_user(user)
    user.admin? ? '/account/products' : main_app.account_root_path
  end

  def ghost_login?
    session[:ghost_login_user_id].present?
  end

  def admin_ghost_login?
    session[:ghost_login_admin_id].present?
  end

  protected

  def accepted_terms
    if spree_current_user
      redirect_to main_app.display_terms_url unless spree_current_user.accepted_terms
    end
  end

  def authenticate_user!
    if spree_current_user.blank?
      redirect_to spree.login_path, notice: "Please log in first."
    end
  end

  def authenticate_school_admin!
    unless (spree_current_user && spree_current_user.has_school_admin_role?)
      redirect_to root_path, notice: "Please log in as school admin."
    end
  end

  def require_http_basic_auth
    return false if self.class.ancestors.include?(Api::BaseController)
    Rails.env.qa? || Rails.env.staging?
  end

end
