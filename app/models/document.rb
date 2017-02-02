class Document < ActiveRecord::Base
  has_attached_file :attachment, {
    path:           "/:class/:attachment/:id_partition/:style/:filename",
    url:            ":s3_alias_url",
    s3_protocol:    "https",
    s3_host_alias:  ENV['s3_bucket_name'],
    styles: lambda{ |a|
      ["image/jpeg", "image/png"].include?( a.content_type ) ? {
        thumb: "360x360>",
        small:  "720x720>",
        medium: "1080x1080>",
        large: "1440x1440>"
      } : {}  }
  }

  validates_presence_of :name, :category
  validates_attachment :attachment, presence: true, content_type: { content_type: /\A*\Z/ }

  include Categorizable, Taggable

  activate_taggble DocumentTag, DocumentTagging

  attr_reader :attachment_remote_url
  def attachment_remote_url=(url_value)
    self.attachment = URI.parse(url_value)
    # Assuming url_value is http://example.com/photos/face.png
    # attachment_file_name == "face.png"
    # attachment_content_type == "image/png"
    @attachment_remote_url = url_value
  end
end
