class Spree::VideoGroup < ActiveRecord::Base
  has_many :videos, class_name: 'Spree::Video'
  has_many :products, class_name: 'Spree::Product'
end
