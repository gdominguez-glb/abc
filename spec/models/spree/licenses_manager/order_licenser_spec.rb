require 'rails_helper'

RSpec.describe Spree::LicensesManager::OrderLicenser do
  let!(:user) { create(:gm_user) }
  let!(:product) { create(:product) }
  let!(:order) { create(:order, user: user) }

  context 'multiple licenses' do
    before(:each) do
      order.contents.add(product.master, 10)
      Spree::LicensesManager::OrderLicenser.new(order).execute
    end

    it "create license from order" do
      expect(user.licensed_products.count).to eq(2)
    end

    it "assign school admin role to user" do
      expect(user.reload.has_school_admin_role?).to eq(true)
    end
  end

  context "single license" do
    before(:each) do
      order.contents.add(product.master, 1)
      Spree::LicensesManager::OrderLicenser.new(order).execute
    end

    it "create license from order" do
      expect(user.licensed_products.count).to eq(1)
    end

    it "assign school admin role to user" do
      expect(user.reload.has_school_admin_role?).to eq(false)
    end
  end

  context "single license with distribution enable" do
    let!(:order) { create(:order, user: user, enable_single_distribution: true) }

    before(:each) do
      order.contents.add(product.master, 1)
      Spree::LicensesManager::OrderLicenser.new(order).execute
    end

    it "create license from order" do
      expect(user.licensed_products.count).to eq(1)
    end

    it "assign school admin role to user" do
      expect(user.reload.has_school_admin_role?).to eq(true)
    end
  end
end
