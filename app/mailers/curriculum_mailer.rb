class CurriculumMailer < ApplicationMailer

  def notify(user, curriculum_mail)
    @curriculum_mail = curriculum_mail
    mail to: user.email, subject: curriculum_mail.subject
  end
end
