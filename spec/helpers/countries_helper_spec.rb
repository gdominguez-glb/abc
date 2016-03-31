require "rails_helper"

RSpec.describe CountriesHelper, type: :helper do
  describe "#country_list" do
    let!(:ca_country) { create(:country, name: 'Canada', iso: 'CA') }
    let!(:us_country) { create(:country, name: 'United States', iso: 'US') }

    it "return countries list with us as first item" do
      expect(helper.country_list[0].iso).to eq('US')
    end
  end
end
