require 'rails_helper'

RSpec.describe Spree::LicensesManager::OrderLicenser do
  let!(:user) { create(:gm_user) }
  let!(:product) { create(:product) }
  let!(:order) { create(:order, user: user) }

  before(:each) do
    order.contents.add(product.master, 10)
    Spree::LicensesManager::OrderLicenser.new(order).execute
  end

  it "create license from order" do
    expect(user.licensed_products.count).to eq(2)
  end
end
