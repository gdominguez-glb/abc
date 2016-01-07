require 'rails_helper'

RSpec.describe Spree::LineItem, type: :model do
  let(:free_product) { create(:product, price: 0, sf_id_product: nil, sf_id_pricebook: nil) }
  let(:paid_product) { create(:product, price: 10, name: 'Paid Product') }
  let(:order) { create(:order, user: nil, email: 'john@foo.com') }

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
    let(:line_item) { create(:line_item, order: order, variant: free_product.master, quantity: 1) }

    it "return false for local" do
      expect(line_item.should_create_salesforce?).to eq(false)
    end
  end

  describe "#attributes_for_salesforce" do
    let(:line_item) { create(:line_item, order: order, variant: paid_product.master, quantity: 1) }

    it "return attributes to sync salesforce" do
      expect(line_item.attributes_for_salesforce).to eq({"OrderId"=>nil, "Quantity"=>1, "UnitPrice"=>10.0, "PricebookEntryId"=>nil, "Description"=>"Paid Product"})
    end
  end

  describe "#skip_salesforce_sync?" do
    let(:fulfillment_order) { create(:order, source: :fulfillment, user: nil, email: 'foo@foo.com') }
    let(:line_item) { create(:line_item, order: fulfillment_order) }

    it "return true for fulfillment order" do
      expect(line_item.skip_salesforce_sync?).to eq(true)
    end
  end
end
