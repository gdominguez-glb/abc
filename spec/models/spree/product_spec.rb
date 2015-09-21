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

  describe "#digital?" do
    let(:product) { create(:product) }

    it "return true if product type is digital" do
      product.product_type = 'Digital'

      expect(product.digital?).to eq(true)
    end

    it "return false if product type is not digital" do
      product.product_type = 'Pdf'
      
      expect(product.digital?).to eq(false)
    end
  end
end
