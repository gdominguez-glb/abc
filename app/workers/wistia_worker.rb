require 'gm_wistia_uploader'

class WistiaWorker
  include Sidekiq::Worker

  def perform(video_id)
    logger.info "** running wistia worker with video id: #{video_id} **"
    video = Spree::Video.find_by(id: video_id)
    if video
      media_data = GmWistiaUploader.new.upload_video(video)
      video.update_wistia_data(media_data)
    end
  end
end
