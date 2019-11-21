# frozen_string_literal: true

module Spree
  module Admin
    class FlipbookItemsController < ResourceController
      belongs_to 'spree/flipbook_leaf', find_by: :id

      def index
        @flipbook_items = @flipbook_leaf.flipbook_items.order(:position)
        @flipbook_item = @flipbook_leaf.flipbook_items.new
      end

      def destroy
        @object.destroy
        respond_to do |format|
          format.html do
            redirect_to admin_product_flipbook_leafs_path(@flipbook_leaf.product)
          end
          format.js {}
        end
      end

      def update_position
        update_positions_with_klass(Spree::FLipbookItem)
        render nothing: true
      end
    end
  end
end
