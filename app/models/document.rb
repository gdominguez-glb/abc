class Document < ActiveRecord::Base
  has_attached_file :attachment, {
    path:           "/:class/:attachment/:id_partition/:style/:filename",
    url:            ":s3_alias_url",
    s3_protocol:    "http",
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

  include Taggable

  activate_taggble DocumentTag, DocumentTagging
end
