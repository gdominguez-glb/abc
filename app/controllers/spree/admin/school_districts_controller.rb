module Spree
  module Admin
    class SchoolDistrictsController < Spree::Admin::BaseController
      include AutocompleteByName

      def index
        autocomplate_by_name(SchoolDistrict)
      end

    end
  end
end
