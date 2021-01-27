class DownloadProduct < ApplicationRecord
  belongs_to :download_page
  belongs_to :product, class_name: 'Spree::Product'

  validates_presence_of :download_page, :product

  acts_as_list scope: :download_page
end
