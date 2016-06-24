class LinkFile < ActiveRecord::Base
  has_attached_file :file, {
    path:           "/:class/:attachment/:id_partition/:style/:filename",
    url:            ":s3_alias_url",
    s3_protocol:    "https",
    s3_host_alias:  ENV['s3_bucket_name']
  }
  validates_attachment :file, presence: true, content_type: { content_type: /\A*\Z/ }
end
