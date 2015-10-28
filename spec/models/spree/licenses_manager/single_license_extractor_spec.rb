require 'rails_helper'

RSpec.describe Spree::LicensesManager::SingleLicenseExtractor do
  let!(:user) { create(:gm_user) }
  let!(:licensed_product) { create(:spree_licensed_product, user: user, quantity: 10) }

  before(:each) do
    Spree::LicensesManager::SingleLicenseExtractor.new(licensed_product).execute
  end

  it "extract one un-distributable license to user" do
    self_license = user.licensed_products.undistributable.last

    expect(user.licensed_products.count).to eq(2)
    expect(self_license).not_to be_nil
    expect(self_license.quantity).to eq(1)
  end

  it "reduce quantity on original license" do
    expect(licensed_product.reload.quantity).to eq(9)
  end

  it "create distribution" do
    distribution = user.product_distributions.last

    expect(distribution).not_to be_nil
    expect(distribution.quantity).to eq(1)
  end
end
