require 'rails_helper'

RSpec.describe ReassignLicensesForm do
  let(:school_admin_user) { create(:gm_user) }
  let(:user) { create(:gm_user) }
  let(:reassign_user) { create(:gm_user) }

  let!(:product) { create(:product, license_length: 365) }
  let!(:licensed_product) { create(:spree_licensed_product, user: school_admin_user, product: product, quantity: 10) }
  let!(:distribution) { create(:spree_product_distribution, from_user: school_admin_user, to_user: user, product: product, quantity: 3) }

  let(:reassign_licenses_form) do
    ReassignLicensesForm.new(licenses_recipients: 'john@doe.com', product_id: product.id, licenses_number: '1', user: user)
  end

  describe "#perform" do
    it "reduce quantity on distribution" do
      reassign_licenses_form.perform
      expect(distribution.reload.quantity).to eq(2)
    end

    it "create new distribution" do
      reassign_licenses_form.perform
      distribution = Spree::ProductDistribution.find_by(email: 'john@doe.com')
      expect(distribution.quantity).to eq(1)
    end
  end
end
