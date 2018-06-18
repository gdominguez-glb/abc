module Spree
  module LicensesManager
    class DeleteFreeProduct
      def initialize(user, product)
        @user = user
        @product = product
      end

      def delete!
        license_products = Spree::LicensedProduct.where(user_id: @user.id, product_id: @product.id).includes(:salesforce_reference)
        sf_ids = license_products.map(&:id_in_salesforce)
        license_products.destroy_all
        ZeroSfAssetQuantityWorker.perform_async(sf_ids)
      end
    end
  end
end
