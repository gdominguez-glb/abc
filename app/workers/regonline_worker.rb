require 'regonline'

class RegonlineWorker
  include Sidekiq::Worker

  def perform
    Regonline.import_events
  end
end
