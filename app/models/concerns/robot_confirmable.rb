module RobotConfirmable
  extend ActiveSupport::Concern

  included do
    attr_accessor :google_recaptcha, :google_recaptcha_required
    validate :google_recaptcha_form, :if => :google_recaptcha_required
  end

  def google_recaptcha_form
    errors.add(:google_recaptcha, "You need to validate that you are not a robot") unless Google::Recaptcha.status(google_recaptcha)[:success]
  end
end