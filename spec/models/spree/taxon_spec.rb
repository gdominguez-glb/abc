require 'rails_helper'

RSpec.describe Spree::Taxon do
  it { should have_many(:video_classifications) }
  it { should have_many(:videos) }

  describe "#applicable_filters" do
    it "only return brand filters" do
      taxon = build(:taxon)

      expect(taxon.applicable_filters.count) == 0
      expect(taxon.applicable_filters[0]['name']) == "Brands"
    end
  end
end
