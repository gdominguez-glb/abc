module Spree
  module Admin
    class StorefrontsController < BaseController
      before_action :set_products

      def show
      end

      # update list
      def create
        params[:positions].each do |id, position|
          @products.find(id).update_column(:position, position)
        end
        render body: nil
      end

      def set_products
        @products = Spree::Product.show_in_storefront.active.where(individual_sale: true).saleable.unarchive
      end
    end
  end
end
