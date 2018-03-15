class LeadContactMailer < ApplicationMailer
  def notify(excel_file_path)
    attachments["lead_contacts_#{Time.now.to_i}.xlsx"] = File.read(excel_file_path)
    mail to: 'julie.huston@greatminds.org', cc: ['jon@jonwilliams.com', 'david.blair@greatminds.org'], subject: 'New leads'
  end
end
