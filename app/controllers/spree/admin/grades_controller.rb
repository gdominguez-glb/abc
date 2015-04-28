module Spree
  module Admin
    class GradesController < ResourceController
      def index
        @grades = Grade.order('position asc')
      end

      def grade_units_select
        @grade_units = @grade.grade_units
        render layout: false
      end
    end
  end
end
