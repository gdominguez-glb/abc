class Spree::Material < ActiveRecord::Base
  acts_as_nested_set scope: :product_id, counter_cache: :children_count

  belongs_to :product, class_name: 'Spree::Product'
  has_many :material_files, class_name: 'Spree::MaterialFile'

  validates_presence_of :name

  searchkick personalize: "user_ids"

  def search_data
    {
      name: name,
      user_ids: (product.orders.pluck(:user_id) rescue [])
    }
  end
end
