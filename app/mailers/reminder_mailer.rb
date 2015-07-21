class ReminderMailer < ApplicationMailer

  def remind(from_user, email, content)
    @from_user = from_user
    mail to: email, subject: "Reminder from #{@from_user.full_name}"
  end
end
