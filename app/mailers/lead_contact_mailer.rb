class LeadContactMailer < ApplicationMailer
  def notify(lead_sf_attrs)
    @lead_sf_attrs = lead_sf_attrs
    mail to: 'julie.huston@greatminds.org', cc: ['jon@jonwilliams.com', 'david.blair@greatminds.org'], subject: 'Received new Lead'
  end
end
