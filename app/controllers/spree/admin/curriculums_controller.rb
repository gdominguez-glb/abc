module Spree
  module Admin
    class CurriculumsController < ResourceController
      def index
        @curriculums = Spree::Curriculum.order('position asc')
      end
    end
  end
end
