module Spree
  module Admin
    class CcOrdersController < BaseController
      before_action :set_payment_methods

      def new
        @cc_order_processor_form = CcOrderProcessorForm.new
        @order = Spree::Order.new
      end

      def create
        @cc_order_processor_form = CcOrderProcessorForm.new(cc_order_processor_params.merge(
          payment_source_params: params[:payment_source],
          admin_user: current_spree_user
        ))
        @order = Spree::Order.new

        if @cc_order_processor_form.valid?
          @cc_order_processor_form.perform
          redirect_to spree.admin_orders_path
        else
          render :new
        end
      end

      private

      def set_payment_methods
        @payment_methods =
          Spree::PaymentMethod.where(
            name: ['Credit Card']
          ).available_on_back_end
      end

      def cc_order_processor_params
        params.require(:cc_order_processor_form).permit(:salesforce_order_id, :amount, :email)
      end
    end
  end
end
