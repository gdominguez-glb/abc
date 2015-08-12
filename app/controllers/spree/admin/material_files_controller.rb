module Spree
  module Admin
    class MaterialFilesController < ResourceController
      belongs_to "spree/material", :find_by => :id

      def index
        @material_files = @material.material_files
        @material_file = @material.material_files.new
      end

      def create
        @object.attributes = permitted_resource_params
        respond_to do |format|
          format.html {
            if @object.save
              flash[:success] = flash_message_for(@object, :successfully_created)
            else
              flash[:error] = @object.errors.full_messages.join(", ")
            end
            redirect_to admin_product_materials_path(@material.product)
          }
          format.js
        end
      end

      def location_after_destroy
        admin_product_materials_path(@material.product)
      end
    end
  end
end
