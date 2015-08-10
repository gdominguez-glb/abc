module Spree
  module Admin
    class MaterialImportJobsController < ResourceController
      belongs_to "spree/product", :find_by => :slug

      def create
        @object.attributes = permitted_resource_params
        path = admin_product_materials_path
        if @object.save
          redirect_to path, notice: 'Queued import job, please come back or refresh this page in a while to check the result.'
        else
          flash[:error] = 'Please upload correct file to import'
          redirect_to path
        end
      end
    end
  end
end
