module Spree
  module LicensesManager
    class OrderCanceller

      def initialize(order)
        @order = order
      end

      def execute
        sf_ids_to_delete = Spree::LicensedProduct.where(order_id: @order.id).map{|lp| lp.id_in_salesforce }.compact

        # delete root licenses, let active record callbacks destroy licenses from distribution
        Spree::LicensedProduct.where(order_id: @order.id).where(product_distribution_id: nil).each do |licensed_product|
          licensed_product.destroy
          Spree::ProductDistribution.where(licensed_product_id: licensed_product.id).destroy_all
        end
        Spree::LicensesManager::OrderCanceller.delay.delete_assets_in_sf(sf_ids_to_delete)
      end

      def self.delete_assets_in_sf(sf_ids)
        sf_client = GmSalesforce::Client.instance.client
        sf_ids.each do |sf_id|
          sf_client.destroy('Asset', sf_id)
        end
      end
    end
  end
end
