class JobsController < ApplicationController
  def index
    @careers_page = Page.find_by(slug: 'careers')
    @jobs = Job.displayable.order(:position)
    @page_title = 'Careers'
  end

  def show
    @job = Job.find(params[:id])
    @page_title = "Careers - #{@job.title}"
  end
end
