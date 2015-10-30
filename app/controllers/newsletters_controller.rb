class NewslettersController < ApplicationController
  def index
    @newsletter = Newsletter.new
    if current_spree_user
      @newsletter.set_attribtues_from_user(current_spree_user)
    end
  end

  def create
    @newsletter = Newsletter.new(newsletter_params)
    if @newsletter.valid?
      @newsletter.perform
    end
  end

  private

  def newsletter_params
    params.require(:newsletter).permit(:first_name, :last_name, :email, lists: [])
  end
end
