class Spree::GroupItem < ApplicationRecord
  belongs_to :group, class_name: 'Spree::Product', foreign_key: 'group_id'
  belongs_to :product, class_name: 'Spree::Product', foreign_key: 'product_id'

  before_create :set_product_storefront_on_create
  after_destroy :set_product_storefront_on_destroy

  def set_product_storefront_on_create
    self.product.update_column(:show_in_storefront, false)
  end

  def set_product_storefront_on_destroy
    if !Spree::GroupItem.where(product_id: self.product_id).exists?
      self.product.update_column(:show_in_storefront, true)
    end
  end
end
