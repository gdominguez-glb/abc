require 'regonline'

namespace :regonline do
  desc "import regonline events"
  task :import_events => :environment do
    Regonline.import_events
    EventPage.reindex
  end

  desc "invisible events"
  task :invisible_events => :environment do
    RegonlineEvent.where(display: true).where("invisible_at < ?", Date.today).update_all(display: false)
  end
end
