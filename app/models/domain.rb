class Domain < ActiveRecord::Base
  belongs_to :school_district
  belongs_to :product, class_name: 'Spree::Product', foreign_key: 'spree_product_id'

  validates :name, presence: true
  validates :school_district, presence: true
  validates :product, presence: true

  def self.products_by_domain(domain: nil, admin: admin)
    product_distributions = admin.licensed_products
      .where('quantity > 0')
      .where(can_be_distributed: true).pluck(:id)

    where(name: domain).where(spree_product_id: product_distributions)
      .includes(:product)
      .map { |domain| [domain.product.name, domain.product.id] }
  end
end
