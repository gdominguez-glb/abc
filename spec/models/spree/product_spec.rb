require 'rails_helper'

RSpec.describe Spree::Product, type: :model do
  it { should belong_to(:video_group).class_name('Spree::VideoGroup') }

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

  describe "assign video group taxon" do
    it "assign taxon with video group name" do
      video_group = create(:spree_video_group, name: 'Teach Eureka')
      product = create(:product, video_group: video_group)
      expect(product.taxons.find_by(name: 'Teach Eureka')).not_to be_nil
    end
  end

  describe "#digital_delivery?" do
    let(:shipping_category) { create(:shipping_category, name: 'Digital Delivery') }

    it "return true if shipping with digital" do
      product = create(:product, shipping_category: shipping_category)

      expect(product.digital_delivery?).to eq(true)
    end

    it "return false if not shipping with digital" do
      product = create(:product)
      
      expect(product.digital_delivery?).to eq(false)
    end
  end
end
