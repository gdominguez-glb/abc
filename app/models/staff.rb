class Staff < ActiveRecord::Base

  enum staff_type: { staff: 0, trustee: 1 }

  include Displayable

  has_attached_file :picture, {
    path:           "/:class/:attachment/:id_partition/:style/:filename",
    url:            ":s3_alias_url",
    s3_protocol:    "http",
    s3_host_alias:  ENV['s3_bucket_name']
  }

  validates_presence_of :name
  validates_attachment :picture, content_type: { content_type: /\A*\Z/ }

  acts_as_list

  searchkick callbacks: :async

  def search_data
    {
      name: name,
      title: title,
      description: description,
      feature: "Staff",
      user_ids: [-1]
    }
  end

end
