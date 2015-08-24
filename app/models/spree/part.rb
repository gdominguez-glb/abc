module Spree
  class Part < ActiveRecord::Base
    belongs_to :bundle, class_name: 'Spree::Product', foreign_key: 'bundle_id'
    belongs_to :product, class_name: 'Spree::Product', foreign_key: 'product_id'

    after_create :remove_can_be_part_flag

    validates :bundle_id,  presence: true
    validates :product_id, presence: true

    protected

    def remove_can_be_part_flag
      parent = Spree::Product.find(bundle_id)
      parent.update_attributes(can_be_part: false)
    end
  end
end
