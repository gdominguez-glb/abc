class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :item, polymorphic: true

  scope :recent, -> { order('created_at desc').limit(10) }
end
