class NotificationMailer < ApplicationMailer

  def notify(user, content)
    @content = content
    mail to: user.email, subject: 'Notificaiton from greatminds'
  end
end
