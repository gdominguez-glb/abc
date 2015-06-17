require 'medium'

namespace :medium do
  desc "import medium posts"
  task :import_posts => :environment do
    Medium::Scraper.new.scrape_publications
  end
end
