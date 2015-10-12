module Spree
  module Admin
    class InklingCodesController < BaseController
      before_action :find_product

      def show
        @inkling_code = @product.inkling_code || Spree::InklingCode.new
      end

      def create
        create_or_update_code
      end

      def update
        create_or_update_code
      end

      private

      def find_product
        @product = Spree::Product.find_by(slug: params[:product_id])
      end

      def create_or_update_code
        @inkling_code = @product.inkling_code || Spree::InklingCode.new(product: @product)
        @inkling_code.update(code: params[:inkling_code][:code])

        redirect_to admin_product_inkling_code_path(@product)
      end
    end
  end
end
