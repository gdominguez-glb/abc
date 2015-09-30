module Spree
  module Admin
    class VideoGroupsController < Spree::Admin::BaseController
      include AutocompleteByName

      def index
        autocomplate_by_name(Spree::VideoGroup, :name)
      end

      def create
        @video_group = Spree::VideoGroup.create(params[:name])

        render json: { id: @video_group.name, name: @video_group.name }
      end

    end
  end
end
