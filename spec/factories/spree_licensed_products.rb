FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :spree_licensed_product, class: 'Spree::LicensedProduct' do
    user { create(:gm_user) }
    product
    quantity { 1 }
    can_be_distributed { true }
    skip_salesforce_create { true }
    after(:create) do |l|
      create(:salesforce_reference, local_object: l)
    end
  end
end
