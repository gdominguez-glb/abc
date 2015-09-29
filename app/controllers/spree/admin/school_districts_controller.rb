module Spree
  module Admin
    class SchoolDistrictsController < Spree::Admin::BaseController

      def index
        @school_districts = SchoolDistrict.page(params[:page])

        if params[:q]
          @school_districts = @school_districts.where("name like ?", "%#{params[:q]}%")
        end

        if params[:ids].present?
          @school_districts = @school_districts.where(id: params[:ids])
        end

        render json: {
          count: @school_districts.count,
          total_count: @school_districts.total_count,
          current_page: (params[:page] ? params[:page].to_i : 1),
          per_page: (params[:per_page] || Kaminari.config.default_per_page),
          pages: @school_districts.num_pages,
          school_districts: @school_districts.map{|vg| { id: vg.id, name: vg.name }}
        }
      end

    end
  end
end
