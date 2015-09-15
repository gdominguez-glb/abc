module Spree
  module LicensesManager
    class LicensesCreator

      def initialize(rows=[])
        @rows = rows
      end

      def execute
        @rows.each do |row|
          create_license(row)
        end
        { success: true }
      end

      def create_license(row)
        # it should support create from user_id/email
        licensed_product = Spree::LicensedProduct.create(
          user_id:        row[:user_id],
          email:          row[:email],
          product:        row[:product],
          quantity:       row[:quantity],
          fulfillment_at: row[:fulfillment_at]
        )
        if licensed_product.quantity > 1
          licensed_product.update(can_be_distributed: true)
          # should i mark the license as distributable if same license product exist and not expire?? and the quantity is 1
          assign_one_as_non_distributable(licensed_product)
        end
      end

      def assign_one_as_non_distributable(licensed_product)
        SingleLicenseExtractor.new(licensed_product).execute
      end
    end
  end
end
