class Notification < ActiveRecord::Base
  belongs_to :notification_trigger
  belongs_to :user, class_name: 'Spree::User'
end
