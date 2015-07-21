require 'rails_helper'

RSpec.describe RevokeLicensesForm do
  let(:school_admin_user) { create(:gm_user) }
  let(:user) { create(:gm_user) }

  let!(:product) { create(:product, license_length: 365) }
  let!(:licensed_product) { create(:spree_licensed_product, user: school_admin_user, product: product, quantity: 10) }
  let!(:distribution) { create(:spree_product_distribution, from_user: school_admin_user, to_user: user, product: product, quantity: 3, licensed_product: licensed_product) }

  let(:revoke_licenses_form) do
    RevokeLicensesForm.new(reason: 'reason 1', product_id: product.id, licenses_number: '1', user: user)
  end

  it "valid with correct info" do
    expect(revoke_licenses_form.valid?).to eq(true)
  end

  describe "validation" do
    it "invalid without product id" do
      revoke_licenses_form.product_id = nil
      expect(revoke_licenses_form.valid?).to eq(false)
    end

    it "invalid without licenses number" do
      revoke_licenses_form.licenses_number = nil
      expect(revoke_licenses_form.valid?).to eq(false)
    end

    it "invaid with too many licenses number" do
      revoke_licenses_form.licenses_number = '4'
      expect(revoke_licenses_form.valid?).to eq(false)
    end
  end

  describe "#perform" do
    before(:each) do
      revoke_licenses_form.perform
    end

    it "revoke licenses" do
      expect(distribution.reload.quantity).to eq(2)
    end

    it "add back the quantity to school admin" do
      expect(licensed_product.reload.quantity).to eq(8)
    end
  end
end
