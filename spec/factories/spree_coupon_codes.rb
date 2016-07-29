FactoryGirl.define do
  factory :spree_coupon_code, :class => 'Spree::CouponCode' do
    code "MyString"
quantity 1
  end

end
