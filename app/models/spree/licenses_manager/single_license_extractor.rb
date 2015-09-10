module Spree
  module LicensesManager
    class SingleLicenseExtractor
      def initialize(licensed_product)
        @licensed_product = licensed_product
      end

      def execute
        @licensed_product.distribute_one_license_to_self
      end
    end
  end
end
