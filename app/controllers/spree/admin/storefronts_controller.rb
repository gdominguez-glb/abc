module Spree
  module Admin
    class StorefrontsController < BaseController

      def show
        @products = Spree::Product.show_in_storefront
      end

      # update list
      def create
        @products = Spree::Product.show_in_storefront
        params[:positions].each do |id, position|
          @products.find(id).update_column(:position, position)
        end
        render nothing: true
      end
    end
  end
end
