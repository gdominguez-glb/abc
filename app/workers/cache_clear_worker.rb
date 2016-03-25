class CacheClearWorker
  include Sidekiq::Worker

  def perform
    Rails.cache.clear
  end
end
