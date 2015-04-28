module Spree
  module Admin
    class GradeUnitsController < ResourceController
      belongs_to "spree/grade"

      def index
        @grade_units = @grade.grade_units.order('position asc')
      end
    end
  end
end
