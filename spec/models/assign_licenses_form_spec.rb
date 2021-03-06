require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe AssignLicensesForm, type: :model do
  let(:school_admin_user) { create(:gm_user) }
  let!(:product) { create(:product, license_length: 365) }
  let!(:licensed_product) { create(:spree_licensed_product, user: school_admin_user, product: product, quantity: 10) }

  let(:assign_licenses_form) do
    AssignLicensesForm.new(licenses_recipients: 'john@doe.com', licenses_ids: [licensed_product.id], licenses_number: '1', user: school_admin_user)
  end

  before(:each) do
    mock_mandrill_delivery
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
      licensed_product = create(:spree_licensed_product, user: school_admin_user, product: product, quantity: 10)
      assign_licenses_form = AssignLicensesForm.new(licenses_recipients: 'john@doe.com', licenses_ids: [licensed_product.id], licenses_number: '9', user: school_admin_user)
      expect(assign_licenses_form.valid?).to eq(true)
    end
  end

  describe "#perform" do
    it "create distributions to user" do
      assign_licenses_form.perform
      LicensesDistributionWorker.drain
      distribution = Spree::ProductDistribution.find_by(email: 'john@doe.com')

      expect(distribution.quantity).to eq(1)
    end

    it "reduce licenses quantity on school admin user" do
      assign_licenses_form.perform
      LicensesDistributionWorker.drain

      expect(licensed_product.reload.quantity).to eq(9)
    end

    context "quantity in multiple licenses" do
      let!(:another_licensed_product) { create(:spree_licensed_product, user: school_admin_user, product: product, quantity: 5) }

      it "able to assign licenses from two licenses" do
        assign_licenses_form = AssignLicensesForm.new(licenses_recipients: 'john@doe.com', licenses_ids: [licensed_product.id, another_licensed_product.id], licenses_number: '13', user: school_admin_user)
        assign_licenses_form.perform
        LicensesDistributionWorker.drain

        expect(licensed_product.reload.quantity).to eq(0)
        expect(another_licensed_product.reload.quantity).to eq(2)
      end
    end
  end

  context "assign multiple license" do
    let(:assign_licenses_form) do
      AssignLicensesForm.new(licenses_recipients: 'john@foo.com', licenses_ids: [licensed_product.id], licenses_number: '3', user: school_admin_user)
    end

    before(:each) do
      assign_licenses_form.perform
      LicensesDistributionWorker.drain
    end


    it "reduce quantity on original license" do
      expect(licensed_product.reload.quantity).to eq(7)
    end

    it "create new license" do
      expect(Spree::LicensedProduct.where(email: 'john@foo.com', quantity: 2).count).to eq(1)
    end

    it "create distribution" do
      distribution = Spree::ProductDistribution.where(from_email: school_admin_user.email, email: 'john@foo.com').first
      expect(distribution.quantity).to eq(3)
    end

    it "mark new license as distributable" do
      licensed_product = Spree::LicensedProduct.where(email: 'john@foo.com').first
      expect(licensed_product.reload.can_be_distributed).to eq(true)
    end

    it "extract one license to user" do
      self_distribution = Spree::ProductDistribution.where(from_email: 'john@foo.com', email: 'john@foo.com').first

      expect(Spree::LicensedProduct.where(email: 'john@foo.com', quantity: 1).count).to eq(1)
      expect(self_distribution.quantity).to eq(1)
    end
  end
end
