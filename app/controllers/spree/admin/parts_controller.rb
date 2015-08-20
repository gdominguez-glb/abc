module Spree
  module Admin
    class PartsController < ResourceController
      before_action :set_product
      skip_before_action :load_resource

      def create
        @part = Spree::Part.new(part_params)
        if @part.save
          flash[:success] = Spree.t('bundles.admin.flash.success.create')
        else
          flash[:error] = Spree.t('bundles.admin.flash.error.create')
        end
        redirect_to location_after_save
      end

      def destroy
        @part = Spree::Part.find(params[:id])
        @part.destroy
        flash[:success] = Spree.t('bundles.admin.flash.success.destroy')
        redirect_to location_after_save
      end

      protected

      def part_params
        params.require(:part).permit([:bundle_id, :product_id])
      end

      def location_after_save
        spree.admin_product_parts_path(@product)
      end

      def set_product
        @product = Spree::Product.find_by(slug: params[:product_id])
      end
    end
  end
end
