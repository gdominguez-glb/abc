class ZeroSfAssetQuantityWorker
  include Sidekiq::Worker

  def perform(sf_ids)
    client = GmSalesforce::Client.instance.client
    sf_ids.compact.reject(&:blank).each do |sf_id|
      client.update('Asset', Id: sf_id, Quantity: 0)
    end
  end
end
