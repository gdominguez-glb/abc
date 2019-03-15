module Spree
  module Admin
    class WhitelistController < ResourceController
      def index
        @country_list = country_list.map do |country|
          [country.name, country.id]
        end

        @us_states_list = Spree::Country.find_by(iso: 'US').states.map do |state|
          [state.name, state.id]
        end
      end

      private

      def country_list
        countries = Spree::Country.order(:name).to_a
        us_index = countries.index {|country| country[:iso] == "US"}
        countries.insert(0, countries.delete_at(us_index))
      end
    end
  end
end
