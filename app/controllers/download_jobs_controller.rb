class DownloadJobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_download_job

  def show
    render json: {
      status: @download_job.status
      url: (@download_job.status == 'done' ? @download_job.file.expiring_url(60*60*60) : '')
    }
  end

  private

  def set_download_job
    @download_job = current_spree_user.download_jobs.find(params[:id])
  end
end
