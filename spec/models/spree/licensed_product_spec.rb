require 'rails_helper'

RSpec.describe Spree::LicensedProduct, type: :model do

  it { should belong_to(:product).class_name('Spree::Product') }
  it { should belong_to(:order).class_name('Spree::Order') }
  it { should belong_to(:user).class_name('Spree::User') }
  it { should belong_to(:admin_user).class_name('Spree::User') }

  it { should validate_numericality_of(:quantity) }
  it { should allow_value('john@doe.com').for(:email) }
  it { should_not allow_value('johndoe.com').for(:email) }

  describe "set user from email" do
    it "set user with email in license" do
      user = create(:gm_user, email: 'hello@foo.com')
      licensed_product = create(:spree_licensed_product, email: 'hello@foo.com', user: nil)
      expect(licensed_product.user).to eq(user)
    end
  end

  describe "fulfillment at" do
    let!(:fulfillment_date) { 100.days.since }
    let!(:product) { create(:product, fulfillment_date: fulfillment_date) }

    it "set product fulfillment date" do
      licensed_product = create(:spree_licensed_product, product: product)

      expect(licensed_product.fulfillment_at).to eq(fulfillment_date)
    end

    it "override fulfillment date if set in license" do
      custom_fulfillment_date = 120.days.since
      licensed_product = create(:spree_licensed_product, product: product, fulfillment_at: custom_fulfillment_date)

      expect(licensed_product.fulfillment_at).to eq(custom_fulfillment_date)
    end
  end

  describe "expire at" do
    let!(:expire_date) { 100.days.since }
    let!(:expire_product) { create(:product, expiration_date: expire_date) }
    let!(:days_product) { create(:product, license_length: 100) }

    it "set expire at from product expiration date" do
      licensed_product = create(:spree_licensed_product, product: expire_product)

      expect(licensed_product.expire_at).to eq(expire_date)
    end

    it "set expire at calculate from days length in product" do
      licensed_product = create(:spree_licensed_product, product: days_product)

      expect(licensed_product.expire_at > 99.days.since).to eq(true)
    end
  end
end
