module Spree
  module Admin
    class LicensesController < BaseController
      before_action :find_user
      before_action :find_license, only: [:edit, :update]

      def index
        @licensed_products = Spree::LicensedProduct.unexpire.where(user_id: @user.id).includes(:product).page(params[:page])
      end

      def edit
      end

      def update
        @licensed_product.update(license_params)
        @licensed_product.product_distribution.update(quantity: @licensed_product.quantity) if @licensed_product.product_distribution
        redirect_to admin_user_licenses_path(@user), notice: 'Update license successfully'
      end

      private

      def find_user
        @user = Spree::User.find(params[:user_id])
      end

      def find_license
        @licensed_product = Spree::LicensedProduct.where(user_id: @user.id).find(params[:id])
      end

      def license_params
        params.require(:licensed_product).permit(:quantity, :fulfillment_at, :expire_at)
      end

    end
  end
end
