require 'rails_helper'

RSpec.describe Spree::LicensesManager::LicensesDistributer do
  let!(:user) { create(:gm_user) }
  let!(:product) { create(:product) }
  let!(:licensed_product) { create(:spree_licensed_product, user: user, product: product, quantity: 10) }
  let!(:user_to_receive_license) { create(:gm_user, email: 'john@doooe.com') }

  before(:each) do
    rows = [
      { email: 'john@doooe.com', quantity: 3  },
      { email: 'jack@dooe.com',  quantity: 4 }
    ]
    Spree::LicensesManager::LicensesDistributer.new(
      user: user,
      product: product,
      rows: rows
    ).execute
  end

  it "distribute license to exist user" do
    licensed_products = user_to_receive_license.licensed_products

    expect(licensed_products.count).to eq(2)
    expect(licensed_products.sum(:quantity)).to eq(3)
  end

  it "distribute license to un-register user" do
    licensed_products = Spree::LicensedProduct.where(email: 'jack@dooe.com')

    expect(licensed_products.count).to eq(2)
    expect(licensed_products.sum(:quantity)).to eq(4)
  end

  it "reduce quantity on original license" do
  end
end
