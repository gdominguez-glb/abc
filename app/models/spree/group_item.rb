class Spree::GroupItem < ActiveRecord::Base
    belongs_to :group, class_name: 'Spree::Product', foreign_key: 'group_id'
    belongs_to :product, class_name: 'Spree::Product', foreign_key: 'product_id'
end
