class DownloadJob < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User'

  serialize :material_ids, Array

  has_attached_file :file
  validates_attachment_content_type :file, :content_type => /\A.*\Z/
end
