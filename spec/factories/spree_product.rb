require 'spree/testing_support/factories'

FactoryGirl.modify do
  factory :product, class: 'Spree::Product' do
    skip_salesforce_create true
    sequence(:sf_id_product)  { |n| n.to_s.rjust(18, '0') }
    sf_id_pricebook 1.to_s.rjust(18, '0')
  end
end
