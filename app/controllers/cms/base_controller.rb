class Cms::BaseController < ApplicationController
  layout 'cms_admin'
  before_action :authenticate_spree_user!
  before_action :authenticate_admin_in_cms!

  private

  def authenticate_admin_in_cms!
    if !current_spree_user.admin?
      redirect_to root_path and return
    end
  end

  def authenticate_vanity_admin_in_cms!
    if !(current_spree_user.admin? || current_spree_user.has_vanity_admin_role?)
      redirect_to root_path and return
    end
  end

  def authenticate_hr_admin_in_cms!
    if !(current_spree_user.admin? || current_spree_user.has_hr_role?)
      redirect_to root_path and return
    end
  end

  def current_ability
    @current_ability ||= CmsAbility.new(current_spree_user)
  end

  def require_params(name, params, to_split)
    _params = params.require(name).permit(params)
    _params[to_split] = _params[to_split].split(',')
    _params
  end
end
