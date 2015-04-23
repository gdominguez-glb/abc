class Cms::BaseController < ApplicationController
  layout 'cms_admin'
  before_action :authenticate_cms_accessor!

  private
  def authenticate_cms_accessor!
    authenticate_spree_user!

    # unless current_user.can_access_cms?
    #   redirect_to home_path, notice: '没有权限访问！'
    # end
  end

  def current_ability
    @current_ability ||= CmsAbility.new(current_user)
  end

end