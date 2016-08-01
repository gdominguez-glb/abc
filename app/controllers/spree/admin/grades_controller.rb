module Spree
  module Admin
    class GradesController < ResourceController
      include AutocompleteByName

      def index
        @grades = Grade.order('position asc')
      end

      def grade_units_select
        @grade_units = @grade.grade_units
        render layout: false
      end

      def search
        autocomplate_by_name(Spree::Grade)
      end
    end
  end
end
