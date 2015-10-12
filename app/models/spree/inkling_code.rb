class Spree::InklingCode < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
end
