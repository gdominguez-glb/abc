class ContentErrorMailer < ApplicationMailer

  def notify(content_error_info={})
    @info = content_error_info
    mail to: "errors.ww@greatminds.org", subject: "English Content Error"
  end
end
