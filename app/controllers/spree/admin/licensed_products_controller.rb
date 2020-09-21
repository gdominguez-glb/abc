module Spree
  module Admin
    class LicensedProductsController < ResourceController
      before_action :set_payment_methods, only: [:new, :create]

      def index
        @licensed_products = Spree::LicensedProduct.joins(:product).includes([:user, :product]).page(params[:page])
      end

      def new
        @new_licenses_form = AdminNewLicensesForm.new
        @order = Spree::Order.new
      end

      def create
        @new_licenses_form = AdminNewLicensesForm.new(new_licenses_form_params.merge(
          payment_source_params: params[:payment_source],
          products_quantity: params[:products],
          admin_user: current_spree_user
        ))
        @order = Spree::Order.new

        if @new_licenses_form.valid?
          @new_licenses_form.perform
          redirect_to spree.admin_licensed_products_path, notice: 'Licenses successfully distributed'
        else
          render :new
        end
      end

      def edit
        @licensed_product = Spree::LicensedProduct.find(params[:id])
      end

      def import
        if request.post?
          result = Spree::LicenseImporter.new(params[:file], params[:fulfillment_at]).import
          if result[:success]
            redirect_to spree.admin_licensed_products_path, notice: 'Imported successfully'
          else
            flash[:error] = result[:error]
            redirect_to spree.import_admin_licensed_products_path
          end
        end
      end

      private

      def set_payment_methods
        @payment_methods =
          Spree::PaymentMethod.where(
            name: ['Purchase Order', 'Credit Card']
          ).available_on_back_end
      end

      def new_licenses_form_params
        params.require(:admin_new_licenses_form).permit(
          :user_id,
          :email,
          :product_ids,
          :quantity,
          :payment_method_id,
          :fulfillment_at,
          :salesforce_order_id,
          :salesforce_account_id,
          :sf_contact_id,
          :enable_single_distribution,
          :allow_fulfill_without_salesforce,
          :amount
        ).to_h
      end
    end
  end
end
