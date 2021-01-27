class Spree::Bookmark < ApplicationRecord
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :bookmarkable, polymorphic: true

  scope :materials, -> { where(bookmarkable_type: 'Spree::Material') }
end
