class ContactWorker
  include Sidekiq::Worker

  def perform(sobject, sf_attrs)
    if Spree::Config[:salesforce_enabled]
      GmSalesforce::Client.instance.create(sobject, sf_attrs)
    end
  end
end
