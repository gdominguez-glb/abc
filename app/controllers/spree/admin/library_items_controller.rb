module Spree
  module Admin
    class LibraryItemsController < ResourceController
      belongs_to "spree/library_leaf", :find_by => :id

      def index
        @library_items = @library_leaf.library_items
        @library_item = @library_leaf.library_items.new
      end

      def create
        @object.attributes = permitted_resource_params
        respond_to do |format|
          format.html {
            if @object.save
              flash[:success] = flash_message_for(@object, :successfully_created)
            else
              flash[:error] = @object.errors.full_messages.join(", ")
            end
            redirect_to admin_product_library_leafs_path(@library_leaf.product)
          }
          format.js
        end
      end

      def location_after_destroy
        admin_product_library_leafs_path(@library_leaf.product)
      end
    end
  end
end
