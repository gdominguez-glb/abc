class Subscription < ActiveRecord::Base
  belongs_to :blog
  belongs_to :user, class_name: 'Spree::User'
end
