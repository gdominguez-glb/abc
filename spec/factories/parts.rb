FactoryBot.define do
  factory :part, class: 'Spree::Part' do
    bundle_id { 1 }
    product_id { 2 }
  end

end
