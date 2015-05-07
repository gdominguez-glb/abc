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

  # comment for video demo
  # if Rails.env.qa? || Rails.env.staging?
  #   http_basic_authenticate_with name: "greatminds", password: "intridea4gm"
  # end

  protected

  def authenticate_user!
    if spree_current_user.blank?
      redirect_to root_path, notice: "Please log in first."
    end
  end
end
