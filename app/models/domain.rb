class Domain < ActiveRecord::Base
  belongs_to :school_district
  belongs_to :product, class_name: 'Spree::Product', foreign_key: 'spree_product_id'

  validates :name, presence: true
  validates :school_district, presence: true
  validates :product, presence: true
end
