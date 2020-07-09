FactoryBot.define do
  factory :salesforce_reference do
    sequence(:id_in_salesforce)  { |n| n.to_s }
    local_object_id { 1 }
    local_object_type { 'Spree::Product' }
  end
end
