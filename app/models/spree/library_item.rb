class Spree::LibraryItem < ApplicationRecord
  belongs_to :library_leaf, class_name: 'Spree::LibraryLeaf'

  validates_presence_of :name

  acts_as_list scope: :library_leaf

  enum item_type: [ :inkling, :pdf ]

  has_attached_file :cover, {
    path:           "/:class/:attachment/:id_partition/:style/:filename",
    # url:            ":s3_alias_url",
    s3_protocol:    "https",
    # s3_host_alias:  ENV['s3_bucket_name'],
    :styles => {
      :medium => "330x220" }
  }
  validates_attachment :cover, presence: true, content_type: { content_type: /\A*\Z/ }

  has_attached_file :attachment, s3_permissions: :private
  validates_attachment :attachment, content_type: { content_type: "application/pdf" } if :pdf?

end
