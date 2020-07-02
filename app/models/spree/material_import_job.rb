class Spree::MaterialImportJob < ApplicationRecord
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :product, class_name: 'Spree::Product'

  has_attached_file :file, s3_permissions: :private
  validates_attachment_content_type :file, content_type: %w(application/zip)

  scope :processing, -> { where(status: 'processing') }

  before_validation(on: :create) do
    self.status = 'pending'
  end

  after_create -> { MaterialImportJobWorker.perform_async(self.id) }
end
