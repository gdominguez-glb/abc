module Spree
  module Admin
    class LicensedProductsController < ResourceController
      def index
        @licensed_products = Spree::LicensedProduct.includes([:user, :product]).page(params[:page])
      end
    end
  end
end
