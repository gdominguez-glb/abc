module CountriesHelper
  # Returns a list of countries with US first, for country dropdowns
  def country_list
    Rails.cache.fetch(:country_list, expires_in: 1.hour) do
      countries = Spree::Country.order(:name).to_a
      us_index = countries.index {|country| country[:iso] == "US"}
      countries.insert(0, countries.delete_at(us_index))
    end
  end
end
