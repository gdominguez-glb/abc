module Spree
  module Admin
    class GroupItemsController < ResourceController
      before_action :set_product
      skip_before_action :load_resource

      def create
        @group_item = Spree::GroupItem.new(group_item_params)
        if @group_item.save
          flash[:success] = 'Successfully create group item'
        else
          flash[:error] = 'Fail to create group item'
        end
        redirect_to location_after_save
      end

      def destroy
        @group_item = Spree::GroupItem.find(params[:id])
        @group_item.destroy
        flash[:success] = "Successfully deleted group item"
        redirect_to location_after_save
      end

      def update_position
        params[:positions].each do |id, position|
          Spree::GroupItem.find_by(group_id: @product.id, product_id: id).update(position: position)
        end
        render body: nil
      end

      protected

      def group_item_params
        params.require(:group_item).permit([:group_id, :product_id])
      end

      def location_after_save
        spree.admin_product_group_items_path(@product)
      end

      def set_product
        @product = Spree::Product.find_by(slug: params[:product_id])
      end
    end
  end
end
