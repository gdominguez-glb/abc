module Spree
  module LicensesManager
    class BulkDistributionRevoker

      def initialize(distributions)
        @distributions = distributions
      end

      def revoke
        Spree::ProductDistribution.transaction do
          @distributions.each do |distribution|
            Spree::LicensesManager::DistributionRevoker.new(distribution).revoke
          end
        end
      end
      
    end
  end
end
