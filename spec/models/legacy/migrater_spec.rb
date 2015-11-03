require 'rails_helper'

RSpec.describe Legacy::Migrater do
  let(:user) { create(:gm_user, email: 'john@doe.com')}
  let!(:product) { create(:product, name: 'Eureka Math') }

  let!(:legacy_user) { create(:legacy_user, email: 'john@doe.com', ee_id: 1101, is_school_admin: true) }
  let!(:legacy_license) { create(:legacy_license, product_id: 12345, user_id: 1101, expiration_date: 1.years.since.strftime('%Y-%m-%d %H:%M:%S'), mapped_name: 'Eureka Math') }

  describe "#execute" do
    before(:each) do
      Legacy::Migrater.new(user).execute
    end

    it "assign school admin role to user if legacy user is school admin" do
      expect(user.reload.has_school_admin_role?).to eq(true)
    end

    it "create license with latest expiration date" do
      licensed_product = user.licensed_products.first
      expect(licensed_product).not_to be_nil
      expect(licensed_product.product).to eq(product)
    end
  end
end
