class ReminderMailer < ApplicationMailer
  def invitation_remind(_from_user, email, _product_names)
    MandrillSender.new.deliver_with_template(
      'invite-reminder',
      email,
      'A friendly reminder to finish registering for your Great Minds account.',
      {}
    )
  end

  def login_remind(_from_user, email)
    MandrillSender.new.deliver_with_template(
      'login-reminder',
      email,
      'A friendly reminder about your Great Minds login',
      {}
    )
  end
end
