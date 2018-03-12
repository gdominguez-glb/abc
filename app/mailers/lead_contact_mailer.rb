class LeadContactMailer < ApplicationMailer
  def notify(lead_sf_attrs)
    @lead_sf_attrs = lead_sf_attrs
    mail to: 'julie.huston@greatminds.org', subject: 'Received new Lead'
  end
end
