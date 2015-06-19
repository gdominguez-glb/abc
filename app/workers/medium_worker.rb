require 'medium'

class MediumWorker
  include Sidekiq::Worker

  def perform
    Medium::Scraper.new.scrape_publications
  end
end
