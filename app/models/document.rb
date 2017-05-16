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
    } : {}  },
    convert_options: {
          :medium => "-quality 80 -interlace Plane",
          :thumb => "-quality 80 -interlace Plane",
          :medium => "-quality 80 -interlace Plane",
          :large => "-quality 80 -interlace Plane"
    },
    :processors => [:thumbnail, :compression]
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

  def image?
    ["image/jpeg", "image/png"].include?( attachment.content_type )
  end

  require 'uri'
  def image_url
    uri =  URI.parse(attachment.url)
    uri.query = [uri.query, {alt: self.alt_text}.to_param].compact.join('&')
    uri.to_s
  end

  require 'rake/pathmap'
  def create_copy!
    copy_doc = self.dup
    copy_doc_name = self.name + ' (copy)'
    copy_attachment_file_name = self.attachment_file_name.pathmap "%X-copy%x"
    copy_doc.name = copy_doc_name

    tmp_file_name = Rails.root.join('tmp', copy_attachment_file_name)
    file = File.new(tmp_file_name, 'wb')
    file.write open(self.attachment.url(:original)).read
    file.close

    copy_doc.attachment = File.new(tmp_file_name)
    copy_doc.save!

    FileUtils.rm(tmp_file_name)
  end
end
