require "open-uri"
require 'open_uri_redirections'

namespace :wistia do
  desc "refresh wistia media status"
  task refresh_media_status: :environment do
    Spree::Video.where.not(wistia_status: 'ready', wistia_hashed_id: nil).find_each do |video|
      begin
        media = Wistia::Media.find(video.wistia_hashed_id)
        preview_image_url = (media.assets.first.url.gsub(/bin$/, 'jpg') << '?video_still_time=1') rescue nil
        video.update(
          wistia_status: media.status,
          wistia_thumbnail_url: (media.thumbnail.url rescue nil),
          preview_image_url: preview_image_url,
          screenshot: (preview_image_url ? open(preview_image_url, allow_redirections: :all) : nil)
        )
      rescue
      end
    end
  end

  desc "Fill empty screenshot for videos"
  task fill_empty_screenshot: :environment do
    Spree::Video.where(wistia_status: 'ready', screenshot_file_size: 0).each do |video|
      video.update(
        screenshot: (video.preview_image_url ? open(video.preview_image_url, allow_redirections: :all) : nil)
      )
    end
  end
end
