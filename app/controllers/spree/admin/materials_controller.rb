module Spree
  module Admin
    class MaterialsController < ResourceController
      belongs_to "spree/product", :find_by => :slug

      before_action :find_product, only: [:bulk_modal, :bulk_create, :delete_confirm]

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

      def destroy
        @object.destroy
      end

      def bulk_create
        @parent = @product.materials.find_by(id: params[:parent_id])
        @materials = params[:names].split(',').map do |name|
          Material.create(parent: @parent, name: name, product: @product)
        end
      end

      def delete_confirm
        @material = @product.materials.find(params[:id])
      end

      def update_position
        if params[:left_id].present?
          left_material = Spree::Material.find(params[:left_id])
          @material.move_to_left_of(left_material)
        end
        if params[:right_id].present?
          right_material = Spree::Material.find(params[:right_id])
          @material.move_to_right_of(right_material)
        end
        @material.save
        render body: nil
      end

      private

      def find_product
        @product = Spree::Product.find_by(slug: params[:product_id])
      end
    end
  end
end
