class Spree::FavoriteProduct < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :product, class_name: 'Spree::Product'

  has_many :taxons, through: :product

  scope :sort_by_taxons, ->(taxonomy_id) {
    joins("left join spree_products on spree_products.id = spree_favorite_products.product_id AND spree_products.deleted_at IS NULL").
    joins("left JOIN spree_products_taxons ON spree_products_taxons.product_id = spree_products.id").
    joins("left JOIN spree_taxons ON spree_taxons.id = spree_products_taxons.taxon_id and spree_taxons.taxonomy_id = #{taxonomy_id}").
    order("spree_taxons.name asc")
  }
end
