class WhatNew < ActiveRecord::Base
  include Viewable, Clickable, Displayable

  has_and_belongs_to_many :products, class_name: 'Spree::Product', join_table: 'products_what_news'

  validates :title, presence: true
end
