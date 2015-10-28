module Spree
  module LicensesManager
    class DistributionRevoker
      def initialize(distribution)
        @distribution = distribution
      end

      def revoke
        Spree::ProductDistribution.transaction do
          Spree::ProductDistribution.where(licensed_product: @distribution.distributed_licensed_product).each do |distribution|
            clear_distribution(distribution)
          end
          @distribution.licensed_product.update(quantity: @distribution.licensed_product.quantity + @distribution.quantity)
          clear_distribution_quantity(@distribution)
        end
      end

      def clear_distribution(distribution)
        Spree::ProductDistribution.where(licensed_product: distribution.distributed_licensed_product).each do |_distribution|
          clear_distribution(_distribution)
        end
        clear_distribution_quantity(distribution)
      end

      def clear_distribution_quantity(distribution)
        distribution.update(quantity: 0)
        distribution.distributed_licensed_product.update(quantity: 0)
      end
    end
  end
end
