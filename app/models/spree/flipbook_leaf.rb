# frozen_string_literal: true

class Spree::FlipbookLeaf < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'

  validates_presence_of :name

  acts_as_list scope: :product

  has_many :flipbook_items, -> {
    order(:position)
  }, class_name: 'Spree::FlipbookItem'
end
