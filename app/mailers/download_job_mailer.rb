class DownloadJobMailer < ApplicationMailer

  def notify(download_job)
    @url = download_job.file.expiring_url(60*60*60)
    mail to: download_job.user.email, subject: 'Your file is ready.'
  end
end
