class Spree::Material < ActiveRecord::Base
  acts_as_nested_set scope: :product_id, counter_cache: :children_count

  belongs_to :product, class_name: 'Spree::Product'
end
