module Spree
  module LicensesManager
    class DeleteFreeProduct
      def initialize(user, product)
        @user = user
        @product = product
      end

      def delete!
        Spree::LicensedProduct.where(user_id: @user.id, product_id: @product.id).destroy_all
      end
    end
  end
end
