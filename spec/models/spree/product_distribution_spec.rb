require 'rails_helper'

RSpec.describe Spree::ProductDistribution, type: :model do
  it { belong_to(:licensed_product).class_name('Spree::LicensedProduct') }
  it { belong_to(:from_user).class_name('Spree::User') }
  it { belong_to(:to_user).class_name('Spree::User') }
  it { belong_to(:product).class_name('Spree::Product') }

  it { should validate_presence_of(:from_user) }
  it { should validate_presence_of(:product) }

  let(:from_user) { create(:gm_user) }
  let(:to_user) { create(:gm_user) }
  let(:reassign_user) { create(:gm_user) }

  let(:product) { create(:product, license_length: 365) }
  let(:licensed_product) { create(:spree_licensed_product, user: from_user, product: product, quantity: 10) }
  let(:distribution) { create(:spree_product_distribution, from_user: from_user, to_user: to_user, product: product, quantity: 1, licensed_product: licensed_product) }

  describe "licensed product creation" do
    before(:each) { distribution }

    it "create licensed product to distribution user" do
      licensed_product = to_user.licensed_products.first
      expect(licensed_product.quantity).to eq(1)
      expect(licensed_product.product_distribution).to eq(distribution)
    end

    it "reduce license quantity from user" do
      expect(licensed_product.reload.quantity).to eq(9)
    end
  end

  describe "#revoke" do
    before(:each) do
      distribution
      distribution.revoke
    end

    it "destroy licensed product" do
      expect(to_user.licensed_products.count).to eq(0)
    end

    it "destroy production distribution" do
      expect(Spree::ProductDistribution.find_by(id: distribution.id)).to eq(nil)
    end

    it "increase original licensed products quantity" do
      expect(licensed_product.reload.quantity).to eq(10)
    end
  end

  describe "#reassign_to" do
    before(:each) do
      distribution
      distribution.reassign_to(reassign_user)
    end

    it "revoke license from original user" do
      expect(to_user.licensed_products.count).to eq(0)
    end

    it "assign license to reassign user" do
      licensed_product = reassign_user.licensed_products.first
      expect(licensed_product).not_to be_nil
      expect(licensed_product.product_distribution).to eq(distribution)
    end
  end
end
