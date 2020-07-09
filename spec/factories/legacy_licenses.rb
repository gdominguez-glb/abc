FactoryBot.define do
  factory :legacy_license, :class => 'Legacy::License' do
    user_id { 1 }
    product_id { 1 }
    expiration_date { "2015-11-03 10:18:35" }
    ee_id { 1 }
  end

end
