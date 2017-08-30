require 'rails_helper'

RSpec.describe Spree::LicensesManager::CouponCodeLicenser do
  let!(:user) { create(:gm_user) }
  let!(:grade) { create(:spree_grade, name: 'PK') }
  let!(:product_a) { create(:product, grades: [grade]) }
  let!(:product_b) { create(:product) }
  let!(:coupon_code) { create(:spree_coupon_code, total_quantity: 10, products: [product_a, product_b]) }

  context "Activate with product_id" do
    before(:each) do
      @result = Spree::LicensesManager::CouponCodeLicenser.new(
        code: coupon_code.code,
        product_id: product_b.id,
        user: user
      ).execute
    end

    it "return success message" do
      expect(@result[:success]).to eq(true)
    end

    it "generate new license" do
      expect(Spree::LicensedProduct.where(user_id: user.id, product_id: product_b.id).exists?).to eq(true)
    end

    it "increase used quantity" do
      expect(coupon_code.reload.used_quantity).to eq(1)
    end
  end

  context "Activate with grade_id" do
    before(:each) do
      @result = Spree::LicensesManager::CouponCodeLicenser.new(
        code: coupon_code.code,
        user: user,
        grade_id: grade.id
      ).execute
    end

    it "return success message" do
      expect(@result[:success]).to eq(true)
    end

    it "generate new license" do
      expect(Spree::LicensedProduct.where(user_id: user.id, product_id: product_a.id).exists?).to eq(true)
    end

    it "increase used quantity" do
      expect(coupon_code.reload.used_quantity).to eq(1)
    end
  end
end
