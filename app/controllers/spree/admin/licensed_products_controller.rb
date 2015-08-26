module Spree
  module Admin
    class LicensedProductsController < ResourceController
      def index
        @licensed_products = Spree::LicensedProduct.joins(:product).includes([:user, :product]).page(params[:page])
      end

      def new
        @licensed_product = Spree::LicensedProduct.new
      end

      def create
        product_ids = params[:licensed_product_product_ids].split(',')
        licensed_products = product_ids.map do |product_id|
          Spree::LicensedProduct.new(permitted_resource_params.merge(product_id: product_id))
        end
        if licensed_products.blank?
          flash[:error] = 'Must select products'
          render :new and return
        end
        if licensed_products.all?{|lp| lp.valid? }
          licensed_products.each{|lp| lp.save}
          redirect_to spree.admin_licensed_products_path
        else
          @licensed_product = licensed_products.first
          render :new
        end
      end

      def import
        if request.post?
          result = Spree::LicenseImporter.new(params[:file]).import
          if result.empty?
            redirect_to spree.admin_licensed_products_path, notice: 'Imported successfully'
          else
            flash[:error] = result[:error]
            redirect_to spree.import_admin_licensed_products_path
          end
        end
      end
    end
  end
end
