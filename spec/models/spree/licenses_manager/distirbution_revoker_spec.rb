require 'rails_helper'

RSpec.describe Spree::LicensesManager::DistributionRevoker do
  let!(:root_user) { create(:gm_user) }
  let!(:product) { create(:product) }
  let!(:root_licensed_product) { create(:spree_licensed_product, product: product, quantity: 10, user: root_user) }

  let!(:second_user) { create(:gm_user) }
  let!(:second_distribution) { create(:spree_product_distribution, product: product, from_user: root_user, to_user: second_user, quantity: 10, licensed_product: root_licensed_product) }
  let!(:second_licensed_product) { create(:spree_licensed_product, product: product, user: second_user, product_distribution: second_distribution, quantity: 7) }

  let!(:third_user) { create(:gm_user) }
  let!(:third_distribution) { create(:spree_product_distribution, product: product, from_user: second_user, to_user: third_user, quantity: 3, licensed_product: second_licensed_product) }
  let!(:third_licensed_product) { create(:spree_licensed_product, product: product, user: third_user, product_distribution: third_distribution, quantity: 3) }

  before(:each) do
    revoker = Spree::LicensesManager::DistributionRevoker.new(second_distribution) 
    revoker.revoke
  end

  it "bring all license back to original license" do
    expect(root_licensed_product.reload.quantity).to eq(20)
  end

  it "clear license and distribution quantity on second user" do
    expect(second_distribution.reload.quantity).to eq(0)
    expect(second_licensed_product.reload.quantity).to eq(0)
  end

  it "clear license and distribution quantity on thrid user" do
    expect(third_distribution.reload.quantity).to eq(0)
    expect(third_licensed_product.reload.quantity).to eq(0)
  end
end
