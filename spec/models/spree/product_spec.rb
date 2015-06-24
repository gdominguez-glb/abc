require 'rails_helper'

RSpec.describe Spree::Product, type: :model do
  describe "#free?" do
    let(:free_product) { create(:product, price: 0) }
    let(:paid_product) { create(:product, price: 123.0)}

    it "return true if master price is 0" do
      expect(free_product.free?).to eq(true)
    end

    it "return false if master price is not 0" do
      expect(paid_product.free?).to eq(false)
    end
  end

  describe "#downloadable?" do
    let(:pdf_product) { create(:product, product_type: 'Pdf') }
    let(:video_product) { create(:product, product_type: 'Video') }

    it "return true for pdf product" do
      expect(pdf_product.downloadable?).to eq(true)
    end

    it "return false for video product" do
      expect(video_product.downloadable?).to eq(false)
    end
  end
end
