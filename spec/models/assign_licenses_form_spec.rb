require 'rails_helper'

RSpec.describe AssignLicensesForm, type: :model do
  let(:school_admin_user) { create(:gm_user) }
  let!(:product) { create(:product, license_length: 365) }
  let!(:licensed_product) { create(:spree_licensed_product, user: school_admin_user, product: product, quantity: 10) }

  let(:assign_licenses_form) do
    AssignLicensesForm.new(licenses_recipients: 'john@doe.com', product_id: product.id, licenses_number: '1', user: school_admin_user)
  end

  describe "validations" do
    it "invalid with incorrect recipients" do
      assign_licenses_form.licenses_recipients = 'john,foo'
      expect(assign_licenses_form.valid?).to eq(false)
      expect(assign_licenses_form.errors[:licenses_recipients]).not_to be_blank
    end

    it "invalid with too many quantity" do
      assign_licenses_form.licenses_number = '20'
      expect(assign_licenses_form.valid?).to eq(false)
      expect(assign_licenses_form.errors[:licenses_number]).not_to be_blank
    end

    it "invalid with wrong quanity" do
      assign_licenses_form.licenses_number = 'abc'
      expect(assign_licenses_form.valid?).to eq(false)
      expect(assign_licenses_form.errors[:licenses_number]).not_to be_blank
    end

    it "valid if more than licensed products of users match the quantity" do
      create(:spree_licensed_product, user: school_admin_user, product: product, quantity: 12)
      assign_licenses_form.licenses_number = '21'
      expect(assign_licenses_form.valid?).to eq(true)
    end
  end

  describe "#perform" do
    it "create distributions to user" do
      assign_licenses_form.perform
      distribution = Spree::ProductDistribution.find_by(email: 'john@doe.com')
      expect(distribution.quantity).to eq(1)
    end

    it "reduce licenses quantity on school admin user" do
      assign_licenses_form.perform
      expect(licensed_product.reload.quantity).to eq(9)
    end

    context "quantity in multiple licenses" do
      let!(:another_licensed_product) { create(:spree_licensed_product, user: school_admin_user, product: product, quantity: 5) }

      it "able to assign licenses from two licenses" do
        assign_licenses_form.licenses_number = 13
        assign_licenses_form.perform

        expect(licensed_product.reload.quantity).to eq(0)
        expect(another_licensed_product.reload.quantity).to eq(2)
      end
    end
  end
end
