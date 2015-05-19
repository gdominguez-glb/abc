require 'gm_wistia_uploader'

class WistiaWorker
  include Sidekiq::Worker

  def perform(digital_id)
    logger.info "** running wistia worker with digital id: #{digital_id} **"
    digital = Spree::Digital.find_by(id: digital_id)
    if digital && digital.attachment.content_type =~ /video/i
      media_data = GmWistiaUploader.new.upload(
        url:         digital.attachment.expiring_url(60*60),
        name:        digital.variant.product.name,
        description: digital.variant.product.description
      )
      digital.update(wistia_id: media_data['id'], wistia_hashed_id: media_data['hashed_id'])
    end
  end
end
