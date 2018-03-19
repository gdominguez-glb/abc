class Spree::PinnedProduct < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :products, class_name: 'Spree::Product'
end
