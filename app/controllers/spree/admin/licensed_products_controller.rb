module Spree
  module Admin
    class LicensedProductsController < ResourceController
      def index
        @licensed_products = Spree::LicensedProduct.joins(:product).includes([:user, :product]).page(params[:page])
      end

      def new
        @new_licenses_form = AdminNewLicensesForm.new
        @order = Spree::Order.new
      end

      def create
        @new_licenses_form = AdminNewLicensesForm.new(new_licenses_form_params.merge(payment_source_params: params[:payment_source]))
        @order = Spree::Order.new

        if @new_licenses_form.valid?
          @new_licenses_form.perform
          redirect_to spree.admin_licensed_products_path
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
          :amount
        )
      end
    end
  end
end
