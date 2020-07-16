require 'rails_helper'

RSpec.describe Spree::LicensesManager::OrderLicenser do
  let!(:user) { create(:gm_user) }
  let!(:product) { create(:product) }
  let!(:order) { create(:order, user: user) }

  context 'multiple licenses' do
    before(:each) do
      Spree::Cart::AddItem.call(order: order,
                                variant: product.master,
                                quantity: 10
                                )
      Spree::LicensesManager::OrderLicenser.new(order).execute
    end

    it "create license from order" do
      expect(user.licensed_products.count).to eq(2)
    end

    it "assign school admin role to user" do
      expect(user.reload.has_school_admin_role?).to eq(true)
    end

    it "assign distributable license to user" do
      expect(Spree::LicensedProduct.where(user_id: user.id, product_id: product.id, quantity: 9, can_be_distributed: true).count).to eq(1)
    end

    it "assign single license to self" do
      expect(Spree::LicensedProduct.where(user_id: user.id, product_id: product.id, quantity: 1, can_be_distributed: false).count).to eq(1)
    end
  end

  context "single license" do
    before(:each) do
      Spree::Cart::AddItem.call(order: order,
                                variant: product.master,
                                quantity: 1
                                )
      Spree::LicensesManager::OrderLicenser.new(order).execute
    end

    it "create license from order" do
      expect(user.licensed_products.count).to eq(1)
    end

    it "create single accessible license" do
      expect(user.licensed_products.where(can_be_distributed: false).count).to eq(1)
    end

    it "assign school admin role to user" do
      expect(user.reload.has_school_admin_role?).to eq(false)
    end
  end

  context "single license with distribution enable" do
    let!(:order) { create(:order, user: user, enable_single_distribution: true) }

    before(:each) do
      Spree::Cart::AddItem.call(order: order,
                                variant: product.master,
                                quantity: 1
                                )
      Spree::LicensesManager::OrderLicenser.new(order).execute
    end

    it "create distributable license from order" do
      expect(user.licensed_products.where(can_be_distributed: true).count).to eq(1)
    end

    it "assign school admin role to user" do
      expect(user.reload.has_school_admin_role?).to eq(true)
    end
  end
end
