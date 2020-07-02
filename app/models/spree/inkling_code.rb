class Spree::InklingCode < ApplicationRecord
  belongs_to :product, class_name: 'Spree::Product'
end
