class Spree::MaterialImportJob < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :product, class_name: 'Spree::Product'

  has_attached_file :file, s3_permissions: :private
  validates_attachment :file, presence: true, content_type: %w(application/zip)
end
