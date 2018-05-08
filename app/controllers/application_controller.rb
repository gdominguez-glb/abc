class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  helper_method :ghost_login?, :admin_ghost_login?

  before_action :accepted_terms
  skip_before_action :accepted_terms, only: [:logout]

  before_action :track_campaign

  before_action :find_current_popup

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

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to not_found_path
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

  def accepted_updated_terms
    return true # Rollback this before new terms is ready
    if spree_current_user && spree_current_user.need_to_accept_updated_terms?
      session['spree_user_return_to'] = request.referrer
      redirect_to main_app.display_terms_url
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

  def update_positions_with_klass(klass)
    params[:positions].each do |id, position|
      klass.find(id).set_list_position(position.to_i + 1)
    end
  end

  def set_page_meta_tags(page)
    if page.seo_data.try(:[], :description).present?
      set_meta_tags description: page.seo_data.try(:[], :description)
    elsif page.description.present?
      set_meta_tags description: page.description
    end
  end

  def track_campaign
    if params[:utm_campaign].present? && params[:utm_content].present?
      session[:utm] = "#{params[:utm_campaign]},#{params[:utm_content]}"
    end
  end

  def find_current_popup
    return if request.try(:path).nil?
    @popup_print = Popup.available.find_by(slug: request.try(:path))

    if @popup_print.present?
      session["popup_#{@popup_print.id}"] ||= 0
      session["popup_#{@popup_print.id}"] += 1

      @popup_print = nil if session["popup_#{@popup_print.id}"] >= 5
    end
  end
end
