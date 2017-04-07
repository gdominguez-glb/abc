class JobsController < ApplicationController
  before_action :redirect_to_new_career

  # Deprecated, we are not using this controller
  def index
    @careers_page = Page.find_by(slug: 'careers')
    @jobs = Job.displayable.order(:position)
    @page_title = 'Careers'
  end

  def show
    @job = Job.find(params[:id])
    @page_title = "Careers - #{@job.title}"
  end

  private
  def redirect_to_new_career
    redirect_to "https://greatminds.recruitee.com/#/"
  end
end
