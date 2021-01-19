class DownloadJob < ApplicationRecord
  belongs_to :user, class_name: 'Spree::User'

  serialize :material_ids, Array

  has_attached_file :file, s3_permissions: :private
  validates_attachment_content_type :file, :content_type => /\A.*\Z/

  after_create -> { DownloadJobWorker.perform_async(self.id) }
end
