namespace :wistia do
  desc "refresh wistia media status"
  task :refresh_media_status => :environment do
    Spree::Video.where.not(wistia_status: 'ready', wistia_hashed_id: nil).find_each do |video|
      begin
        media = Wistia::Media.find(video.wistia_hashed_id)
        video.update(wistia_status: media.status, wistia_thumbnail_url: (media.thumbnail.url rescue nil))
      rescue
      end
    end
  end
end
