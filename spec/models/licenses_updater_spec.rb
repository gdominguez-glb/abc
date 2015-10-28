require 'rails_helper'

RSpec.describe LicensesUpdater, type: :model do
  let!(:school_admin_user) { create(:gm_user) }
  let!(:user) { create(:gm_user) }
  let!(:product) { create(:product) }
  let!(:original_licensed_product) { create(:spree_licensed_product, product: product, user: school_admin_user, quantity: 20) }
  let!(:distribution) { create(:spree_product_distribution, licensed_product: original_licensed_product, from_user: school_admin_user, to_user: user, quantity: 5) }
  let!(:licensed_product) { create(:spree_licensed_product, product: product, product_distribution: distribution, quantity: 5) }

  context "assign more quantity" do
    before(:each) do
      params = {
        distribution.id => {
          'quantity' => 7
        }
      }
      updater = LicensesUpdater.new(product_distributions: params, user: school_admin_user)
      updater.perform
    end

    it "reduce quantity on original license" do
      expect(original_licensed_product.reload.quantity).to eq(18)
    end

    it "increase quantity on license" do
      expect(licensed_product.reload.quantity).to eq(7)
    end

    it "increase quantity on distribution" do
      expect(distribution.reload.quantity).to eq(7)
    end
  end

  context "reduce quantity" do
    before(:each) do
      params = {
        distribution.id => {
          'quantity' => 3
        }
      }
      updater = LicensesUpdater.new(product_distributions: params, user: school_admin_user)
      updater.perform
    end

    it "increase quantity on original license" do
      expect(original_licensed_product.reload.quantity).to eq(22)
    end

    it "reduce quantity on license" do
      expect(licensed_product.reload.quantity).to eq(3)
    end

    it "reduce quantity on distribution" do
      expect(distribution.reload.quantity).to eq(3)
    end
  end
end
