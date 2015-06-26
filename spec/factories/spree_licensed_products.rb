FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :spree_licensed_product, :class => 'Spree::LicensedProduct' do
    user { create(:user, email: generate(:email), first_name: 'John', last_name: 'Doe', school_district: create(:school_district)) }
    product
    quantity 1
  end

end
