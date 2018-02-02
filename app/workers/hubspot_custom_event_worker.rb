require 'rest-client'

class HubspotCustomEventWorker
  include Sidekiq::Worker

  def perform(email)
    name = "Eureka Digital Suite - 30 Day Trial Purchase"
    name += " (#{Rails.env})" if !Rails.env.production?
    
    url = "http://track.hubspot.com/v1/event"
    RestClient.get(url, { params: { '_a' => ENV['hubspot_portal_id'], '_n' => name, email: email }})
  end
end
