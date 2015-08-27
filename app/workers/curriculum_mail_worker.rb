class CurriculumMailWorker
  include Sidekiq::Worker

  def perform(curriculum_mail_id)
    curriculum_mail = CurriculumMail.find(curriculum_mail_id)
    curriculum_mail.update(status: :processing)
    Spree::User.find_each do |user|
      if user.email_notifications["receive_#{curriculum_mail.curriculum.downcase}".to_sym] == true
        CurriculumMailer.notify(user, curriculum_mail).deliver_later
      end
    end
    curriculum_mail.update(status: :done)
  end
end
