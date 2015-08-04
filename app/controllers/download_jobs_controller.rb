class DownloadJobsController < ApplicationController
  def show
    @download_job = DownloadJob.find(params[:id])
    render json: {
      status: @download_job.status
    }
  end

  def download
    @download_job = DownloadJob.find(params[:id])
    redirect_to @download_job.file.url
  end
end
