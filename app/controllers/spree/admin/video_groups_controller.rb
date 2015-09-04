module Spree
  module Admin
    class VideoGroupsController < Spree::Admin::BaseController
      def index
        @video_groups = Spree::VideoGroup.page(params[:page])

        if params[:q]
          @video_groups = @video_groups.where("name like ?", "%#{params[:q]}%")
        end

        render json: {
          count: @video_groups.count,
          total_count: @video_groups.total_count,
          current_page: (params[:page] ? params[:page].to_i : 1),
          per_page: (params[:per_page] || Kaminari.config.default_per_page),
          pages: @video_groups.num_pages,
          video_groups: @video_groups.map{|vg| { id: vg.name, name: vg.name }}
        }
      end

      def create
        @video_group = Spree::VideoGroup.create(params[:name])

        render json: { id: @video_group.name, name: @video_group.name }
      end

    end
  end
end
