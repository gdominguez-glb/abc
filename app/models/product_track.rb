class ProductTrack < ApplicationRecord
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :material, class_name: 'Spree::Material'
end
