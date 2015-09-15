require 'rails_helper'

RSpec.describe Spree::Order, type: :model do
  let(:product_with_license_length) { create(:product, license_length: 360, license_text: 'test') }
  let(:product_without_license_length) { create(:product, license_length: nil, license_text: nil) }
  let(:license_line_item) { create(:line_item, order: order, variant: product_with_license_length.master, :price => 1.0, :quantity => 2) }
  let(:plain_line_item) { create(:line_item, order: order, variant: product_without_license_length.master, :price => 1.0, :quantity => 2) }
  let(:user) { create(:gm_user) }
  let(:order) { create(:order, user: user) }

  describe "#has_license_products?" do
    it "return true with products that has license text" do
      license_line_item
      expect(order.reload.has_license_products?).to eq(true)
    end

    it "return false with producs that dont have license text" do
      plain_line_item
      expect(order.reload.has_license_products?).to eq(false)
    end
  end

  describe "#create_licensed_products!" do
    it "create licensed product for order user" do
      license_line_item
      order.reload.create_licensed_products!
      expect(order.user.licensed_products.count).to eq(2)
    end
  end

  describe "#valid_terms_and_conditions?" do
    it "return false if product is not licensed product" do
      license_line_item
      order.reload.valid_terms_and_conditions?
      expect(order.valid?).to eq(true)
    end

    it "return false if product is licensed product but user not accept terms" do
      order = create(:order, user: create(:gm_user), terms_and_conditions: false)
      create(:line_item, order: order, variant: product_with_license_length.master, :price => 1.0, :quantity => 2)
      order.reload.valid_terms_and_conditions?
      expect(order.errors[:terms_and_conditions].empty?).to eq(false)
    end

    it "return true if product is licensed_product and user accepted terms" do
      order = create(:order, user: create(:gm_user), terms_and_conditions: true)
      create(:line_item, order: order, variant: product_with_license_length.master, :price => 1.0, :quantity => 2)
      order.reload.valid_terms_and_conditions?
      expect(order.valid?).to eq(true)
    end
  end

  describe "#log_purchase_activity!" do
    it "create activity on product purchase" do
      order = plain_line_item.order
      order.reload.log_purchase_activity!
      activity = user.activities.last
      expect(activity.item).to eq(product_without_license_length)
    end
  end
end
