class AccountController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_school_admin!, only: [:admin]

  def index
  end

  def settings
  end

  def profile
  end

  def save_profile
    if spree_current_user.update(user_params)
      redirect_to '/account/settings', notice: "Saved profile successfully"
    else
      render :edit_profile
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :address, :interested_subject, :interested_grade_level, :school_name, :heard_from)
  end
end
