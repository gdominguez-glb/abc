namespace :wistia do
  desc "refresh wistia media status"
  task :refresh_media_status => :environment do
    Spree::Video.where.not(wistia_status: 'ready', wistia_hashed_id: nil).find_each do |video|
      begin
        media = Wistia::Media.find(video.wistia_hashed_id)
        preview_image_url = (media.assets.first.url.gsub(/bin$/, 'jpg') << '?video_still_time=1') rescue nil
        video.update(wistia_status: media.status, wistia_thumbnail_url: (media.thumbnail.url rescue nil), preview_image_url: preview_image_url)
      rescue
      end
    end
  end
end
