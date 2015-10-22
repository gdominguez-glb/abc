require 'rails_helper'

RSpec.describe Spree::ProductDistribution, type: :model do
  it { should belong_to(:licensed_product).class_name('Spree::LicensedProduct') }
  it { should belong_to(:from_user).class_name('Spree::User') }
  it { should belong_to(:to_user).class_name('Spree::User') }
  it { should belong_to(:product).class_name('Spree::Product') }

  it { should have_one(:distributed_licensed_product).class_name('Spree::LicensedProduct').dependent(:destroy) }

  it { should validate_presence_of(:from_user) }
  it { should validate_presence_of(:product) }
  it { should validate_presence_of(:licensed_product) }

  let(:from_user) { create(:gm_user) }
  let(:to_user) { create(:gm_user) }
  let(:reassign_user) { create(:gm_user) }

  let(:product) { create(:product, license_length: 365) }
  let(:licensed_product) { create(:spree_licensed_product, user: from_user, product: product, quantity: 10) }
  let(:distribution) { create(:spree_product_distribution, from_user: from_user, to_user: to_user, product: product, quantity: 2, licensed_product: licensed_product) }

  describe "licensed product creation" do
    before(:each) { distribution }

    it "create licensed product to distribution user" do
      licensed_product = to_user.licensed_products.first
      expect(licensed_product.quantity).to eq(2)
      expect(licensed_product.product_distribution).to eq(distribution)
    end

    it "reduce license quantity from user" do
      expect(licensed_product.reload.quantity).to eq(8)
    end
  end

  describe "#revoke" do
    before(:each) do
      distribution
      distribution.revoke
    end

    it "increase license quantity back to original license" do
      expect(licensed_product.reload.quantity).to eq(10)
    end

    it "destroy distribution" do
      expect(Spree::ProductDistribution.find_by(id: distribution.id)).to eq(nil)
    end
  end
end
