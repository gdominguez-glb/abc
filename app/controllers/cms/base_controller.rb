class Cms::BaseController < ApplicationController
  layout 'cms_admin'
  before_action :authenticate_cms_accessor!

  private

  def authenticate_cms_accessor!
    authenticate_spree_user!
    unless current_spree_user.has_admin_role?
      redirect_to '/'
    end
  end

  def current_ability
    @current_ability ||= CmsAbility.new(current_spree_user)
  end

  def update_positions_with_klass(klass)
    params[:positions].each do |id, position|
      klass.find(id).set_list_position(position.to_i + 1)
    end
  end
end
