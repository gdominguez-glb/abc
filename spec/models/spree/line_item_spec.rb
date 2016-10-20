require 'rails_helper'

RSpec.describe Spree::LineItem, type: :model do
  let(:free_product) { create(:product, price: 0, sf_id_product: nil, sf_id_pricebook: nil) }
  let(:paid_product) { create(:product, price: 10, name: 'Paid Product') }
  let(:order) { create(:order, user: nil, email: 'john@foo.com') }
  let(:normal_order) { create(:order, source: :web, user: nil, email: 'foo@foo.com') }

  describe ".sobject_name" do
    it 'map to salesforce object' do
      expect(Spree::LineItem.sobject_name).to eq('OrderItem')
    end
  end

  describe ".local_only?" do
    context "local" do
      let(:line_item) { create(:line_item, order: order, variant: free_product.master, quantity: 1) }

      it "return true for local line item" do
        expect(line_item.local_only?).to eq(true)
      end
    end

    context "not local" do
      let(:line_item) { create(:line_item, order: order, variant: paid_product.master, quantity: 1) }

      it "return false for nont local line item" do
        expect(line_item.local_only?).to eq(false)
      end
    end
  end

  describe "#should_create_salesforce?" do
    context "local order" do
      let(:line_item) { create(:line_item, order: order, variant: free_product.master, quantity: 1) }

      it "return false for local" do
        expect(line_item.should_create_salesforce?).to eq(false)
      end
    end

    context "complete order" do
      let(:user) { create(:gm_user) }
      let(:complete_order) { create(:order, state: 'complete', user: user) }
      let(:sf_product) { create(:product) }
      let!(:salesforce_reference) { create(:salesforce_reference, local_object: sf_product, id_in_salesforce: 'sf_123') }
      let(:line_item) { create(:line_item, order: complete_order, variant: sf_product.master, quantity: 1) }

      it "return true for complete order for salesforce product" do
        expect(line_item.should_create_salesforce?).to eq(true)
      end
    end
  end

  describe "#attributes_for_salesforce" do
    let(:line_item) { create(:line_item, order: order, variant: paid_product.master, quantity: 1) }

    it "return attributes to sync salesforce" do
      expect(line_item.attributes_for_salesforce).to eq({"OrderId"=>nil, "Quantity"=>1, "UnitPrice"=>10.0, "PricebookEntryId"=>nil, "Description"=>"Paid Product"})
    end
  end

  describe "#skip_salesforce_sync?" do
    context "fulfillment order" do
      let(:fulfillment_order) { create(:order, source: :fulfillment, user: nil, email: 'foo@foo.com') }
      let(:line_item) { create(:line_item, order: fulfillment_order) }

      it "return true for fulfillment order" do
        expect(line_item.skip_salesforce_sync?).to eq(true)
      end
    end

    context "web order" do
      let(:line_item) { create(:line_item, order: normal_order) }

      it "return false for web order" do
        expect(line_item.skip_salesforce_sync?).to eq(false)
      end
    end
  end

  describe ".attributes_from_salesforce_object" do
    it "merge line item quantity and price from sfo" do
      sfo = Hashie::Mash.new(Quantity: 2, UnitPrice: 15)
      attrs = Spree::LineItem.attributes_from_salesforce_object(sfo)
      expect(attrs[:quantity]).to eq(2)
      expect(attrs[:price]).to eq(15)
    end
  end

  describe ".find_or_create_by_salesforce_object" do
    let(:line_item) { create(:line_item, order: normal_order) }
    let!(:salesforce_reference) { create(:salesforce_reference, id_in_salesforce: 'l123', local_object: line_item) }

    it "find exist salesforce object" do
      sfo = Hashie::Mash.new(Id: 'l123')
      expect(Spree::LineItem.find_or_create_by_salesforce_object(sfo)).to eq(line_item)
    end
  end
end
