class Activity < ApplicationRecord
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :item, polymorphic: true

  scope :recent, -> { order('created_at desc').limit(10) }
  scope :login, -> { where(action: 'login') }
  scope :in_last_days, ->(days){ where('created_at > ?', days.days.ago) }
end
