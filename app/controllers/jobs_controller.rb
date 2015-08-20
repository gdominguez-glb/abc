class JobsController < ApplicationController
  def index
    @jobs = Job.displayable
  end

  def show
    @job = Job.find(params[:id])
  end
end
