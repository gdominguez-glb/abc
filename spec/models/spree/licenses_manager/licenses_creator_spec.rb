require 'rails_helper'

RSpec.describe Spree::LicensesManager::LicensesCreator do
  let!(:user) { create(:gm_user, email: 'john@doe.com') }
  let!(:days_product) { create(:product, license_length: 200) }
  let!(:fulfillment_date_product) { create(:product, fulfillment_date: 10.days.from_now) }

  # days product
  # fulfillment/expiration date in product
  describe "days product license" do
    before(:each) do
      rows = [
        { email: user.email, product: days_product, quantity: 10 },
      ]
      creator = Spree::LicensesManager::LicensesCreator.new(rows)
      creator.execute
    end

    it "create two licenses for days product, one as non-distributable" do
      expect(user.licensed_products.count).to eq(2)
      expect(user.licensed_products.where(can_be_distributed: false).count).to eq(1)
    end

    it "set fulfillment date and expire date" do
      licensed_product = user.licensed_products.first

      expect(licensed_product.fulfillment_at).not_to be_nil
      expect(licensed_product.expire_at).not_to be_nil
    end
  end

end
