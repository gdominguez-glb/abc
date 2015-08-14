class Spree::Material < ActiveRecord::Base
  acts_as_nested_set scope: :product_id, order_column: :position, counter_cache: :children_count

  belongs_to :product, class_name: 'Spree::Product'
  has_many :material_files, class_name: 'Spree::MaterialFile'

  validates_presence_of :name

  def child_index=(idx)
    move_to_child_with_index(parent, idx.to_i) unless self.new_record?
  end

end
