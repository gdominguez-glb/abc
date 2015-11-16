class JobsController < ApplicationController
  def index
    @careers_page = Page.find_by(slug: 'careers')
    @jobs = Job.displayable
  end

  def show
    @job = Job.find(params[:id])
  end
end
