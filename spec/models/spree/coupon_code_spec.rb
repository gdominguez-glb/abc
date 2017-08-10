require 'rails_helper'

RSpec.describe Spree::CouponCode, type: :model do
  it { should belong_to(:school_district) }
  it { should have_many(:coupon_code_products).class_name('Spree::CouponCodeProduct') }
  it { should have_many(:products).class_name('Spree::Product') }
  it { should have_one(:order).class_name('Spree::Order') }

  let(:product) { create(:product) }
  let(:school_district) { create(:school_district) }
  let(:coupon_code) { create(:spree_coupon_code, school_district: school_district, products: [product], total_quantity: 10) }

  describe "#available?" do
    it "available when used quantity is less than total quantity" do
      coupon_code.used_quantity = 0
      expect(coupon_code.available?).to eq(true)
    end

    it "not available when used quantity is equal to total quantity" do
      coupon_code.used_quantity = 10
      expect(coupon_code.available?).to eq(false)
    end
  end

  describe "#increase_used_quantity!" do
    it "increased used quantity by one" do
      coupon_code.increase_used_quantity!
      expect(coupon_code.used_quantity).to eq(1)
    end
  end

  it "generate code when code is not empty" do
    expect(coupon_code.code.present?).to eq(true)
  end

  it "not generate code when code is specified" do
    coupon_code = create(:spree_coupon_code, school_district: school_district, products: [product], total_quantity: 10, code: 'CUSTOM_CODE')
    expect(coupon_code.code).to eq('CUSTOM_CODE')
  end
end
