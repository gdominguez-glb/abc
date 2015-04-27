module Spree
  module Admin
    class GradesController < ResourceController
      def index
        @grades = Grade.order('position asc')
      end
    end
  end
end
