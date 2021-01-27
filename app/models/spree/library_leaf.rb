class Spree::LibraryLeaf < ApplicationRecord
  belongs_to :product, class_name: 'Spree::Product'

  validates_presence_of :name

  acts_as_list scope: :product

  has_many :library_items, ->{ order(:position) }, class_name: 'Spree::LibraryItem'
end
