namespace :wistia do
  desc "refresh wistia media status"
  task :refresh_media_status => :environment do
    Spree::Digital.where.not(wistia_status: 'ready', wistia_hashed_id: nil).find_each do |digital|
      begin
        media = Wistia::Media.find(digital.wistia_hashed_id)
        digital.update(wistia_status: media.status)
      rescue
      end
    end
  end
end
