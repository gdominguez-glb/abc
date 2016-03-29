module CountriesHelper
  # Returns a list of countries with US first, for country dropdowns
  def country_list
    Rails.cache.fetch(:country_list, expires_in: 1.hour) do
      us_index = Spree::Country.all.index {|country| country[:iso] == "US"}
      countries = Spree::Country.all.to_a
      countries.insert(0, countries.delete_at(us_index))
    end
  end
end
