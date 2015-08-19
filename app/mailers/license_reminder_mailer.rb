class LicenseReminderMailer < ApplicationMailer

  def remind(attrs={})
    @user              = attrs[:user]
    @products          = attrs[:products]
    @days              = attrs[:days]
    @is_district_admin = attrs[:is_district_admin] || false
    mail to: @user.email, subject: "Your licenses are expiring"
  end
end
