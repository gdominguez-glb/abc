require 'wistia'
require 'httparty'

class GmWistiaUploader

  UPLOAD_API = 'https://upload.wistia.com'

  def upload_digital(digital)
    upload({
      url:         digital.attachment.expiring_url(60*60*24*7),
      name:        digital.variant.product.name,
      description: digital.variant.product.description
    })
  end

  def upload_video(video)
    upload({
      url:         video.file.expiring_url(60*60*24*7),
      name:        video.title,
      description: video.description
    })
  end

  def upload(options={})
    raise "Must specify url to upload" if options[:url].blank?
    params = {
      api_password: ENV['WISTIA_API_PASSWORD'],
      url:          options[:url],
      project_id:   project_id,
      name:         options[:name],
      description:  options[:description],
    }
    response = HTTParty.post(UPLOAD_API, { body: params })
    JSON.parse(response.body)
  end

  def project_id
    return @project_id if @project_id
    projects = Wistia::Project.find(:all)
    project = projects.find{|p| p.name == "greatminds-#{Rails.env}" }
    @project_id = project.try(:id)
  end
end
