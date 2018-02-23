require 'rest-client'

class HubspotCustomEventWorker
  include Sidekiq::Worker

  def perform(name, email)
    name += " (#{Rails.env})" if !Rails.env.production?
    
    url = "http://track.hubspot.com/v1/event"
    RestClient.get(url, { params: { '_a' => ENV['hubspot_portal_id'], '_n' => name, email: email }})
  end
end
