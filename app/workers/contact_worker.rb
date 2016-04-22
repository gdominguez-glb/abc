class ContactWorker
  include Sidekiq::Worker

  def perform(sobject, sf_attrs)
    GmSalesforce::Client.instance.create(sobject, sf_attrs)
  end
end
