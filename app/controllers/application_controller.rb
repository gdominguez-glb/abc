class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_ability
    @current_ability ||= Spree::Ability.new(current_user)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :root, alert: exception.message
  end

  if Rails.env.qa? || Rails.env.staging?
    http_basic_authenticate_with name: ENV['auth_username'], password: ENV['auth_password']
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
    user.admin? ? '/store/admin' : main_app.account_root_path
  end

  protected

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
end
