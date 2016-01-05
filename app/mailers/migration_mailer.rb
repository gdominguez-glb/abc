class MigrationMailer < ApplicationMailer

  def notify(attrs={})
    @email = attrs[:email]
    @user_name = [attrs[:first_name], attrs[:last_name]].compact.join(' ')
    mail to: attrs[:email], subject: 'Migration'
  end
end
