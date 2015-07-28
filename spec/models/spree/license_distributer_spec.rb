require 'rails_helper'

RSpec.describe Spree::LicenseDistributer do
  let(:school_admin_user) { create(:gm_user) }
  let!(:product) { create(:product, license_length: 365) }
  let!(:licensed_product) { create(:spree_licensed_product, user: school_admin_user, product: product, quantity: 10) }

  let(:license_distributer) { Spree::LicenseDistributer.new(user: school_admin_user, product_id: product.id) }

  describe "#distribute_licenses" do
    it "distribute licenses to users from rows" do
      rows = [
        { 'email' => 'john@foo.com', 'quantity' => '1' }
      ]
      license_distributer.distribute_licenses(rows)

      expect(licensed_product.reload.quantity).to eq(9)
      expect(Spree::LicensedProduct.find_by(email: 'john@foo.com').quantity).to eq(1)
    end

    it "distribute licenses to users from multiple licenses source" do
      another_licensed_product = create(:spree_licensed_product, user: school_admin_user, product: product, quantity: 5)
      rows = [
        { 'email' => 'john@foo.com', 'quantity' => '13' }
      ]
      license_distributer.distribute_licenses(rows)

      expect(licensed_product.reload.quantity).to eq(0)
      expect(another_licensed_product.reload.quantity).to eq(2)
      expect(Spree::LicensedProduct.where(email: 'john@foo.com').first.quantity).to eq(10)
      expect(Spree::LicensedProduct.where(email: 'john@foo.com').last.quantity).to eq(3)
    end
  end
end
