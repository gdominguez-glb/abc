module Spree
  module Admin
    class MaterialsController < ResourceController
      belongs_to "spree/product", :find_by => :slug

      before_action :find_product, only: [:bulk_modal, :bulk_create]

      def index
        @materials = @product.materials.roots
      end

      def new
        @material = @product.materials.new(parent_id: params[:parent_id])
      end

      def edit
        @material = @product.materials.find(params[:id])
      end

      def bulk_modal
      end

      def bulk_create
        @parent = @product.materials.find_by(id: params[:parent_id])
        @materials = params[:names].split(',').map do |name|
          Material.create(parent: @parent, name: name, product: @product)
        end
      end

      private

      def find_product
        @product = Spree::Product.find_by(slug: params[:product_id])
      end
    end
  end
end
