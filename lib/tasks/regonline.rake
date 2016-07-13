require 'regonline'

namespace :regonline do
  desc "import regonline events"
  task :import_events => :environment do
    Regonline.import_events
    EventPage.reindex
  end
end
