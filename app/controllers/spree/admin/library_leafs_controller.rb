module Spree
  module Admin
    class LibraryLeafsController < ResourceController
      belongs_to "spree/product", :find_by => :slug

      before_action :find_product, only: [:bulk_modal, :bulk_create, :delete_confirm]

      def index
        @library_leafs = @product.library_leafs.order(:position)
      end

      def new
        @library_leaf = @product.library_leafs.new(product_id: @product.id)
      end

      def edit
        @library_leaf = @product.library_leafs.find(params[:id])
      end

      def bulk_modal
      end

      def destroy
        @object.destroy
      end

      def update_position
        params[:positions].each do |id, position|
          Spree::LibraryLeaf.find(id).set_list_position(position.to_i + 1)
        end
        render nothing: true
      end

      private

      def find_product
        @product = Spree::Product.find_by(slug: params[:product_id])
      end
    end
  end
end
