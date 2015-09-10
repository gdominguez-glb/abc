class Spree::Bookmark < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :bookmarkable, polymorphic: true

  scope :materials, -> { where(bookmarkable_type: 'Spree::Material') }
end
