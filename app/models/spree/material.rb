class Spree::Material < ActiveRecord::Base
  acts_as_nested_set scope: :product_id, counter_cache: :children_count

  belongs_to :product, class_name: 'Spree::Product'
  has_many :material_files, class_name: 'Spree::MaterialFile'

  validates_presence_of :name
end
