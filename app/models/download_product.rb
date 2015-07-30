class DownloadProduct < ActiveRecord::Base
  belongs_to :download_page
  belongs_to :product, class_name: 'Spree::Product'

  validates_presence_of :download_page, :product
end
