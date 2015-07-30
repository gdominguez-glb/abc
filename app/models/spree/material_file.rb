class Spree::MaterialFile < ActiveRecord::Base
  belongs_to :material, class_name: 'Spree::Material'

  has_attached_file :file
  validates_attachment :file, presence: true, content_type: { content_type: /\A*\Z/ }
end
