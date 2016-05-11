class ReminderMailer < ApplicationMailer

  def invitation_remind(from_user, email, product_names)
    @from_user = from_user
    @product_names = product_names
    mail to: email, subject: "#{@from_user.full_name} wants you to register for your Great Minds account."
  end

  def login_remind(from_user, email)
    @from_user = from_user
    mail to: email, subject: "Friendly reminder from #{@from_user.full_name}"
  end

end
