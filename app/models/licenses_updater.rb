class LicensesUpdater
  include ActiveModel::Model

  attr_accessor :product_distributions, :user

  validate :must_have_enough_quantity

  def perform
    Spree::ProductDistribution.transaction do
      distributions_iterator do |distribution, quantity|
        add_quantity = quantity - distribution.distributed_licensed_product.quantity
        if add_quantity > 0
          increase_licenses_quantity(distribution, add_quantity)
        elsif add_quantity < 0
          decrease_licenses_quantity(distribution, add_quantity.abs)
        end
      end
    end
  end

  def increase_licenses_quantity(distribution, quantity)
    distribution.increase_quantity!(quantity)
    distribution.licensed_product.decrease_quantity!(quantity)
  end

  def decrease_licenses_quantity(distribution, quantity)
    distribution.decrease_quantity!(quantity)
    distribution.licensed_product.increase_quantity!(quantity)
  end

  def must_have_enough_quantity
    distributions_iterator do |distribution, quantity|
      add_quantity = quantity - distribution.quantity
      if (quantity > distribution.distributed_licensed_product.quantity) || (add_quantity > 0 && add_quantity > user.licensed_products.where(product_id: distribution.product_id).sum(:quantity))
        self.errors.add(:base, "Invalid licenses quantity")
      end
    end
  end

  def distributions_iterator(&block)
    product_distributions.each do |distribution_id, attrs|
      quantity = attrs['quantity'].to_i
      distribution = user.product_distributions.find(distribution_id)
      block.call(distribution, quantity)
    end
  end
end
