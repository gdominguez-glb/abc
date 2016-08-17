require 'rails_helper'

RSpec.describe Spree::LicensesManager::SingleLicenseDistributer do
  let!(:user) { create(:gm_user) }
  let!(:product) { create(:product) }
  let!(:licensed_product) { create(:spree_licensed_product, user: user, quantity: 1, can_be_distributed: false, product: product) }
  let!(:reference_licensed_product) { create(:spree_licensed_product, user: user, quantity: 10, can_be_distributed: true, product: product) }

  before(:each) do
    Spree::LicensesManager::SingleLicenseDistributer.new(user.email).execute
  end

  it "create distribution for the single license" do
    product_distribution = Spree::ProductDistribution.where(licensed_product_id: licensed_product.id).first
    distributed_licensed_product = Spree::LicensedProduct.where(product_distribution_id: product_distribution.id).last

    expect(product_distribution).not_to be_nil
    expect(distributed_licensed_product.quantity).to eq(1)
    expect(distributed_licensed_product.can_be_distributed).to eq(false)
    licensed_product.reload
    expect(licensed_product.quantity).to eq(0)
    expect(licensed_product.can_be_distributed).to eq(true)
  end
end
