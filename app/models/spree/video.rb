class Spree::Video < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'

  validates_presence_of :title, :description

  has_attached_file :file, s3_permissions: :private, s3_headers: { "Content-Disposition" => "attachment" }
  validates_attachment :file, content_type: { content_type: /\A*\Z/ }
end
