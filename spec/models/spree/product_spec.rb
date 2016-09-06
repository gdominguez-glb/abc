require 'rails_helper'

RSpec.describe Spree::Product, type: :model do
  it { should belong_to(:video_group).class_name('Spree::VideoGroup') }
  it { should have_one(:inkling_code).class_name('Spree::InklingCode') }

  let(:product) { create(:product) }

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

  describe "#parts?" do
    it "return false without any parts" do
      expect(product.parts?).to eq(false)
    end

    it "return true with parts" do
      create(:part, bundle: product, product: create(:product))

      expect(product.reload.parts?).to eq(true)
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

  describe "#fulfillmentable?" do
    it "return true if fulfillment date is empty" do
      product.fulfillment_date = nil

      expect(product.fulfillmentable?).to eq(true)
    end

    it "return true if fulfillment date is past" do
      product.fulfillment_date = 1.days.ago

      expect(product.fulfillmentable?).to eq(true)
    end

    it "return false if fulfillment date is future" do
      product.fulfillment_date = 2.days.since

      expect(product.fulfillmentable?).to eq(false)
    end
  end

  describe "#expired?" do
    it "return false if expiration date is empty" do
      product.expiration_date = nil

      expect(product.expired?).to eq(false)
    end

    it "return false if expiration_date is in future" do
      product.expiration_date = 2.days.since

      expect(product.expired?).to eq(false)
    end

    it "return true if expiration date is past" do
      product.expiration_date = 1.days.ago

      expect(product.expired?).to eq(true)
    end
  end

  describe ".with_taxons" do
    it "filter with taxon ids" do
      taxon = create(:taxon, name: 'Test')
      product.taxons << taxon
      expect(Spree::Product.with_taxons([taxon])).to eq([product])
    end
  end
end
