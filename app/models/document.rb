class Document < ActiveRecord::Base
  has_attached_file :attachment, {
    path:           "/:class/:attachment/:id_partition/:style/:filename",
    url:            ":s3_alias_url",
    s3_protocol:    "http",
    s3_host_alias:  ENV['s3_bucket_name']
  }

  validates_presence_of :name, :category
  validates_attachment :attachment, presence: true, content_type: { content_type: /\A*\Z/ }

  acts_as_taggable
end
