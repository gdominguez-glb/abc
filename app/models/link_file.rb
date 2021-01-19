class LinkFile < ApplicationRecord
  has_attached_file :file, {
    path:           "/:class/:attachment/:id_partition/:style/:filename",
    url:            ":s3_alias_url",
    s3_protocol:    "https",
    s3_host_alias:  ENV['s3_bucket_name']
  }
  validates_attachment :file, presence: true, content_type: { content_type: /\A*\Z/ }

  before_save :set_slug

  private

    def set_slug
      self.slug = File.basename(self.file_file_name, File.extname(self.file_file_name))
    end
end
