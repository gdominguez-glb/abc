class Spree::MaterialFile < ActiveRecord::Base
  belongs_to :material, class_name: 'Spree::Material', counter_cache: true

  has_attached_file :file, s3_permissions: :private, s3_headers: { "Content-Disposition" => "attachment" }
  validates_attachment :file, presence: true, content_type: { content_type: /\A*\Z/ }
end
