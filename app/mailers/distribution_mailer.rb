class DistributionMailer < ApplicationMailer

  def notify(distribution)
    @distribution = distribution
    email = distribution.to_user ? distribution.to_user.email : distribution.email
    mail to: email, subject: "You just received a new license distribution."
  end
end
