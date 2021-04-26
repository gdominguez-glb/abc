module Spree
  module Admin
    class LibraryItemsController < ResourceController
      belongs_to "spree/library_leaf", :find_by => :id

      def index
        @library_items = @library_leaf.library_items.order(:position)
        @library_item = @library_leaf.library_items.new
      end

      def destroy
        @object.destroy
        respond_to do |format|
          format.html{
            redirect_to admin_product_library_leafs_path(@library_leaf.product)
          }
          format.js{}
        end
      end

      def update_position
        update_positions_with_klass(Spree::LibraryItem)
        render body: nil
      end
    end
  end
end
