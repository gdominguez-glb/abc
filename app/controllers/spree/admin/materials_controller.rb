module Spree
  module Admin
    class MaterialsController < ResourceController
      belongs_to "spree/product", :find_by => :slug

      def index
        @materials = @product.materials.roots
      end

      def new
        @material = @product.materials.new(parent_id: params[:parent_id])
      end

      def edit
        @material = @product.materials.find(params[:id])
      end
    end
  end
end
