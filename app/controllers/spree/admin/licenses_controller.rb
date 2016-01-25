module Spree
  module Admin
    class LicensesController < BaseController
      before_action :find_user

      def index
        @licensed_products = Spree::LicensedProduct.where(user_id: @user.id).includes(:product).page(params[:page])
      end

      def edit
      end

      def update
      end

      private

      def find_user
        @user = Spree::User.find(params[:user_id])
      end
    end
  end
end
