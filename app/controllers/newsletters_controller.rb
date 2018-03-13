class NewslettersController < ApplicationController
  def index
    newsletter_url = "http://gm.greatminds.org/great-minds-subscription-preferences"
    if current_spree_user
      newsletter_url += "?#{ { email: current_spree_user.email }.to_param }"
    end
    redirect_to newsletter_url and return
    # @page_title = 'Newsletter'
    # @newsletter = Newsletter.new(role: 'Parent', state: current_spree_user.try(:state_name))
    # if current_spree_user
    #   @newsletter.set_attribtues_from_user(current_spree_user)
    # end
  end

  def create
    @newsletter = Newsletter.new(newsletter_params)
    if @newsletter.valid?
      @newsletter.perform
    end
    respond_to do |format|
      format.js {}
      format.html { redirect_to newsletters_path, notice: 'Update successfully.' }
    end
  end

  private

  def newsletter_params
    params.require(:newsletter).permit(:first_name, :last_name, :email, :zip_code, :role, :state, lists: [])
  end
end
