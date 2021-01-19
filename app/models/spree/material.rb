class Spree::Material < ApplicationRecord
  acts_as_nested_set scope: :product_id, counter_cache: :children_count

  belongs_to :product, class_name: 'Spree::Product'
  has_many :material_files, class_name: 'Spree::MaterialFile', dependent: :destroy

  validates_presence_of :name

  LINK_ICON_OPTIONS = [['Link', 'open_in_browser'], ['Video Play', 'play_arrow']]

  def should_index?
    product ? true : false
  end

  def search_data
    {
      name: name,
      user_ids: find_user_ids_to_index
    }
  end

  def find_user_ids_to_index
    group_ids = Spree::GroupItem.where(product_id: product_id).pluck(:group_id)
    Spree::LicensedProduct.available.where(product_id: [product_id]+group_ids).distinct(:user_id).map(&:user_id).compact.uniq
  rescue
    []
  end
end
