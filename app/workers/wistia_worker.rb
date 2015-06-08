require 'gm_wistia_uploader'

class WistiaWorker
  include Sidekiq::Worker

  def perform(digital_id)
    logger.info "** running wistia worker with digital id: #{digital_id} **"
    digital = Spree::Digital.find_by(id: digital_id)
    if digital && digital.video?
      media_data = GmWistiaUploader.new.upload_digital(digital)
      digital.update_wistia_data(media_data)
    end
  end
end
