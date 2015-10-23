require 'spree/testing_support/factories'
FactoryGirl.modify do
  factory :product, class: 'Spree::Product' do
    skip_salesforce_create true
    sequence(:sf_id_product)  { |n| n }
    sf_id_pricebook 1
    after(:create) do |o|
      create(:salesforce_reference, local_object: o)
    end
  end
end
