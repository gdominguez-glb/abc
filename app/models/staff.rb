class Staff < ActiveRecord::Base
  has_attached_file :picture, {
    path:           "/:class/:attachment/:id_partition/:style/:filename",
    url:            ":s3_alias_url",
    s3_protocol:    "http",
    s3_host_alias:  ENV['s3_bucket_name']
  }

  acts_as_list
end
