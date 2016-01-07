require 'rails_helper'

RSpec.describe Spree::Variant, type: :model do
  let(:variant) { create(:variant) }

  describe "#free?" do
    it "return true if price is 0" do
      variant.price = 0
      expect(variant.free?).to eq(true)
    end

    it "return false if price is larger than 0" do
      variant.price = 120
      expect(variant.free?).to eq(false)
    end
  end
end
