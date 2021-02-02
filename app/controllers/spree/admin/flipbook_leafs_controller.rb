# frozen_string_literal: true

module Spree
  module Admin
    class FlipbookLeafsController < ResourceController
      belongs_to 'spree/product', find_by: :slug

      before_action :find_product, only: [:bulk_modal, :bulk_create, :delete_confirm]

      def index
        @flipbook_leafs = @product.flipbook_leafs
      end

      def new
        @library_leaf = @product.flipbook_leafs.new(product_id: @product.id)
      end

      def edit
        @library_leaf = @product.flipbook_leafs.find(params[:id])
      end

      def destroy
        @object.destroy
      end

      def update_position
        update_positions_with_klass(Spree::LibraryLeaf)
        render body: nil
      end

      private

      def find_product
        @product = Spree::Product.find_by(slug: params[:product_id])
      end
    end
  end
end
