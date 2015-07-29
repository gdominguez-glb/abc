class Spree::MaterialFile < ActiveRecord::Base
  belongs_to :material, class_name: 'Spree::Material'

  has_attached_file :file
end
