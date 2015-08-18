module Spree
  module Admin
    class VideosController < ResourceController
      def index
        @videos = Spree::Video.page(params[:page])
      end
    end
  end
end

