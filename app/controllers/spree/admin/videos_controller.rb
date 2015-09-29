module Spree
  module Admin
    class VideosController < ResourceController
      def index
        @search = Spree::Video.ransack(params[:q])
        @videos = @search.result.includes(:video_group).page(params[:page])
      end

      protected

      def permitted_resource_params
        _params = params.require(:video).permit!
        if _params[:taxon_ids].present?
          _params[:taxon_ids] = _params[:taxon_ids].split(',')
        end
        _params
      end
    end
  end
end
