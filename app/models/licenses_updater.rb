class LicensesUpdater
  include ActiveModel::Model

  attr_accessor :product_distributions, :user

  validate :must_have_enough_quantity

  def perform
    distributions_iterator do |distribution, quantity|
      add_quantity = quantity - distribution.quantity
      if quantity == 0
        distribution.licensed_product.increase_quantity!(distribution.quantity)
        distribution.destroy
      elsif add_quantity > 0
        distribution.increase_quantity!(add_quantity)
        distribution.licensed_product.decrease_quantity!(add_quantity)
      elsif add_quantity < 0
        distribution.decrease_quantity!(add_quantity.abs)
        distribution.licensed_product.increase_quantity!(add_quantity.abs)
      end
    end
  end

  def must_have_enough_quantity
    distributions_iterator do |distribution, quantity|
      add_quantity = quantity - distribution.quantity
      if add_quantity > 0 && add_quantity > user.licensed_products.where(product_id: distribution.product_id).sum(:quantity)
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
