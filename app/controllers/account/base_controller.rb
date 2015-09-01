class Account::BaseController < ApplicationController
  before_action :authenticate_user!
  layout 'account'

  def become
    unless spree_current_user.admin?
      redirect_to account_root_path, notice: 'Permission denied'
      return
    end
    user = Spree::User.where(id: params[:id]).first
    unless user
      redirect_to account_root_path, notice: 'Could not find user'
      return
    end
    sign_in(:spree_user, user, bypass: true)
    redirect_to account_root_path # or user_root_url
  end
end
