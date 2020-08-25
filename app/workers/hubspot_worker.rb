class HubspotWorker
  include Sidekiq::Worker

  def perform(guid, object)
    Hubspot::Form.find(guid).submit(object)
  end
end
